provider "google" {
  project = var.project
  region = var.region
  zone = var.zone
}

# Network and Subnet
resource "google_compute_network" "custom_vpc" {
 name =    "custom-vpc"
 auto_create_subnetworks = false

}
resource "google_compute_subnetwork" "custom_subnet" {
    name = "custom-subnet"
    ip_cidr_range = "10.0.0.0/24"
    region = var.region
    network = google_compute_network.custom_vpc.id

}

# Firewall

resource "google_compute_firewall" "allow_http" {
  name = "allow-http"
  network = google_compute_network.custom_vpc.name

  allow {
    protocol = "tcp"
    ports = ["80","22"]
  }
  target_tags = ["web-server", "ssh"]
  source_ranges = ["0.0.0.0/0"] 
}

# Instance template

resource "google_compute_instance_template" "web_template" {
  name_prefix = "web-template-"
  machine_type = "e2-medium"
  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete = true
    boot = true
  }
  network_interface {
    network = google_compute_network.custom_vpc.id
    subnetwork = google_compute_subnetwork.custom_subnet.id
    access_config {
      
    }
  }

  metadata_startup_script = file("${path.module}/startup.sh")
  
  tags = [ "web-server","ssh" ]
  lifecycle {
    create_before_destroy = true
  }
}

# Managed Instance Group

resource "google_compute_instance_group_manager" "web_mig" {
  name = "web-mig"
  base_instance_name = "web"
  zone = var.zone
  version {
    instance_template = google_compute_instance_template.web_template.id
  }
  # Rolling update policy
  update_policy {
    type                    = "PROACTIVE"     # Automatically update instances
    minimal_action          = "REPLACE"       # Replace VMs when template changes
    max_surge_fixed         = 1               # Create 1 extra VM at a time
    max_unavailable_fixed   = 0               # Don’t allow downtime
                          # Wait for 30s before replacing next
  }
  target_size = 2
  named_port {
    name = "http"
    port = 80
  }
}

# Autoscaler

resource "google_compute_autoscaler" "web_autoscaler" {
    name = "web-autoscaler"
    zone = var.zone
    target = google_compute_instance_group_manager.web_mig.id
    autoscaling_policy {
      max_replicas = 5
      min_replicas = 2
      cpu_utilization {
        target = 0.6
      }
    }
}

# Load Balancer

# 1> Health check

resource "google_compute_health_check" "http_health" {
  name = "http-health"
  check_interval_sec = 5
  timeout_sec = 5
  healthy_threshold = 2
  unhealthy_threshold = 2
  http_health_check {
    port = 80
  }
}

# 2> Backend Srvice

resource "google_compute_backend_service" "default" {
  name = "web-backend"
  protocol = "HTTP"
  port_name = "http"
  timeout_sec = 10
  connection_draining_timeout_sec = 30
  health_checks = [ google_compute_health_check.http_health.id ]
  load_balancing_scheme = "EXTERNAL"
  backend {
    group = google_compute_instance_group_manager.web_mig.instance_group  
  }
}

# 3> URL Map

resource "google_compute_url_map" "default" {
  name = "web-map"
  default_service = google_compute_backend_service.default.id
}

# 4> Target Proxy

resource "google_compute_target_http_proxy" "default" {
  name = "http-proxy"
  url_map = google_compute_url_map.default.id
}

# 5> Global Forwarding rule

resource "google_compute_global_forwarding_rule" "default" {
  name = "http-rule"
  target = google_compute_target_http_proxy.default.id
  port_range = "80"
}





