Day 4 – Revision Notes (Load Balancer + MIG + Instance Template in GCP with Terraform)
1. Instance Template

Definition: A reusable configuration (blueprint) for creating VMs.

Contents:

Machine type (e.g., e2-micro)

Boot disk image (e.g., debian-11)

Metadata startup script

Network tags (e.g., http-server)

Service account & scopes

👉 Why needed?
Instead of configuring each VM manually, we define one template and use it for a group of instances.

📌 Interview Qs:

What is an Instance Template?

Can it be updated? → No, they are immutable. To change, you create a new one and update your MIG to use it.

2. Startup Script (Metadata)

Purpose: Automates instance setup on boot.

Example:

#! /bin/bash
apt-get update
apt-get install -y apache2
systemctl start apache2
echo "Hello from $(hostname)" > /var/www/html/index.html


Ensures every VM in the MIG is ready to serve traffic.

👉 Why important?
Without it, new instances would come up blank → health checks fail → LB backend unhealthy.

📌 Interview Qs:

What is a startup script and when would you use it?

Difference between startup script vs image baking? → Startup script runs at boot, image baking builds everything into a custom image.

3. Managed Instance Group (MIG)

Definition: A group of identical VMs created from an instance template.

Features:

Autoscaling (based on CPU/utilization metrics)

Self-healing (replaces failed instances automatically)

Rolling updates (replace old template with new)

Terraform Resource:

resource "google_compute_instance_group_manager" "default" {
  name               = "web-mig"
  base_instance_name = "web"
  zone               = "us-central1-a"
  version {
    instance_template = google_compute_instance_template.web-template.self_link
  }
  target_size        = 2
}


📌 Interview Qs:

Difference between MIG and Unmanaged Instance Group (UIG)?

How does MIG handle failures?

How do you roll out an update to all VMs in MIG?

4. Firewall Rule

Why needed? → By default, no inbound access.

Example:

resource "google_compute_firewall" "default" {
  name    = "allow-http"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  target_tags = ["http-server"]
}


Opens port 80 for web traffic.

📌 Interview Qs:

How do you expose an application running in GCP?

What’s the difference between firewall rule vs IAM policy?

5. Health Check

Used by LB to verify backend instance health.

Example:

resource "google_compute_health_check" "default" {
  name               = "basic-http-healthcheck"
  check_interval_sec = 5
  timeout_sec        = 5
  http_health_check {
    port = 80
  }
}


If instance doesn’t respond → marked unhealthy → traffic won’t be routed.

📌 Interview Qs:

What happens if all backends fail a health check?

How is health check different from monitoring?

6. Backend Service

Connects health checks + MIG.

Defines:

Load balancing mode (e.g., UTILIZATION)

Protocol (HTTP)

Capacity allocation

📌 Interview Qs:

How does backend service distribute traffic?

What role does health check play in backend service?

7. Load Balancer (HTTP)

Components:

Backend Service → MIG

Health Check

URL Map → routes traffic

Target Proxy → accepts requests

Forwarding Rule → binds external IP + port

👉 Classic Application Load Balancer in GCP.

📌 Interview Qs:

Difference between Global vs Regional LB in GCP?

Layer 4 vs Layer 7 LB?

How does LB interact with health checks?

8. Terraform Specific Concepts

lifecycle { prevent_destroy = true }

Prevents accidental deletion of critical resources (like templates).

Immutability of Templates:

Terraform replaces instead of modifying.

Debugging MIG + LB:

Always check service status with systemctl.

Use curl localhost to validate app response.

🔑 High-Level Architecture Recap

Instance Template → defines VM config

MIG → manages identical VMs

Startup Script → ensures apps are installed/configured

Firewall Rule → allows inbound traffic on port 80

Health Check → validates VMs are serving traffic

Backend Service → connects MIG to LB

HTTP Load Balancer → distributes external traffic