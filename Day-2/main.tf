resource "google_compute_instance" "vm_instance" {
  name = var.instance_name
  machine_type = var.machine_type
  zone = var.zone
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network = "default"
    access_config {
      #Ephemeral Public IP
    }
  }

  service_account {
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]

  }
  metadata = {
    ssh-keys = "terraform:${file("C:/Users/prern/.ssh/id_rsa.pub")}"
  }
}