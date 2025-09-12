provider "google" {
  project = var.project_id
  region = var.region
  zone = var.zone
}
# Inastance template
resource "google_compute_instance_template" "web-template" {
  name_prefix = "web-template-"
  machine_type = "e2-micro"
  tags = ["http-server"]
  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete = true
    boot = true
  }
  
  network_interface {
    network = "default"
    access_config {
      #publicIP
    }
    
  }
metadata_startup_script = <<-EOT
#!/bin/bash
  apt-get update -y
  apt-get install -y apache2
  systemctl start apache2
  systemctl enable apache2
  echo "Hello from $(hostname)" > /var/www/html/index.html
EOT

service_account {
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
}   
lifecycle {
  create_before_destroy = true
  #prevent_destroy = true
}
}
#Managed Instance group
resource "google_compute_instance_group_manager" "default" {
  name = "web-mig"
  base_instance_name = "web"
  #region = var.region
  version {
    instance_template = google_compute_instance_template.web-template.id
  }
  target_size = var.vm_count
  named_port {
    name = "http"
    port = 80
  }
}

#Health check

resource "google_compute_health_check" "default" {
  name = "basic-http-healthcheck"
  check_interval_sec = 5
  timeout_sec        = 5
  healthy_threshold  = 2
  unhealthy_threshold = 2
  http_health_check {
    port = 80
  }
}

#backend Service
resource "google_compute_backend_service" "default" {
  name = "eab-backend"
  protocol = "HTTP"
  port_name = "http"
  load_balancing_scheme = "EXTERNAL"  
  timeout_sec =10  
  health_checks = [google_compute_health_check.default.self_link]
  backend {
    group = google_compute_instance_group_manager.default.instance_group
  }
}
#URL Map
resource "google_compute_url_map" "default" {
    name = "web-map"
    default_service = google_compute_backend_service.default.id
  
}
#HTTP Proxy
resource "google_compute_target_http_proxy" "default" {
  name = "http-proxy"
  url_map = google_compute_url_map.default.id
}

#Global forwarding rule

resource "google_compute_global_forwarding_rule" "default" {
  name = "http-rule"
  target = google_compute_target_http_proxy.default.id
  port_range = "80"
}

#Firewall Rule
resource "google_compute_firewall" "default" {
  name = "allow-http"
  network = "default"
  allow {
    protocol = "tcp"
    ports = ["80"]
  }
  target_tags = ["http-server"]
  source_ranges = ["0.0.0.0/0"]     
}
