provider "google" {
  project = var.project_id
  region = var.region
  zone = var.zone
}
#Custom VPC
resource "google_compute_network" "custom_vpc" {
  name = var.vpc_name
  auto_create_subnetworks = false
}


#Subnets inside VPC
resource "google_compute_subnetwork" "custom_subnet" {
  name = var.subnet_name
  ip_cidr_range = "10.0.0.0/24"
  region = var.region
  network = google_compute_network.custom_vpc.id
}

#Firewall Rules
resource "google_compute_firewall" "allow_ssh_http" {
 name = var.firewall_name
 network = google_compute_network.custom_vpc.name
 allow {
   protocol = "tcp"
   ports = ["22","80"]
 }
 source_ranges = ["0.0.0.0/0"]
}

#Update VM to use custom network

resource "google_compute_instance" "vm_instance" {
  name = "day-3"
  machine_type = "e2-micro"
  zone = var.zone
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network = google_compute_network.custom_vpc.id
    subnetwork = google_compute_subnetwork.custom_subnet.id

    access_config {
      #public IP
    }
  }
  metadata = {
    ssh-keys = "terraform:${file("~/.ssh/id_rsa.pub")}"

  }
}
 

