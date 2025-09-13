terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      #version = "~> 6.0"
    }
  }
}


provider "google" {
  project = var.project_id
  region = var.region
}

# Create GCS Bucket
resource "google_storage_bucket" "static_site" {
  name = "${var.bucket_name}-${var.project_id}"
  location = var.region
  force_destroy = true
  website {
    main_page_suffix = "index.html"
    not_found_page = "404.html"
  }
}
# Upload HTML file

resource "google_storage_bucket_object" "index" {
  name = "index.html"
  bucket = google_storage_bucket.static_site.name
  source = "index.html"
  content_type = "text/html"
}

# Upload 404.html file

resource "google_storage_bucket_object" "error" {
  name = "404.html"
  bucket = google_storage_bucket.static_site.name
  source = "404.html"
  content_type = "text/html"
}

# Make Bucket Public

resource "google_storage_bucket_iam_binding" "public_rule" {
  bucket = google_storage_bucket.static_site.name
  role = "roles/storage.objectViewer"
  members = [ "allUsers", ]
}

# 1. Backend Bucket with CDN enabled
resource "google_compute_backend_bucket" "static_cdn_backend" {
  name        = "static-cdn-backend"
  bucket_name = google_storage_bucket.static_site.name
  enable_cdn  = true
}

# 2. URL Map
resource "google_compute_url_map" "cdn_url_map" {
  name            = "cdn-url-map"
  default_service = google_compute_backend_bucket.static_cdn_backend.id
}
# 3. Target HTTP Proxy (no SSL for now)
resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "http-proxy"
  url_map = google_compute_url_map.cdn_url_map.id
}
# 4. Global Forwarding Rule (assigns IP)
resource "google_compute_global_forwarding_rule" "http_rule" {
  name                  = "http-forwarding-rule"
  target                = google_compute_target_http_proxy.http_proxy.id
  port_range            = "80"
  load_balancing_scheme = "EXTERNAL"
  ip_protocol           = "TCP"
}
