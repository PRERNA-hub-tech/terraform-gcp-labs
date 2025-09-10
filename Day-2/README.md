📒 Day 2 – VM Instance with Terraform
📂 Files

variables.tf → Declared variables (project_id, region, zone, machine_type, image, etc.).

terraform.tfvars → Values for variables (separates config vs data).

main.tf → Actual infra definition.

🖥️ Resource Created

Compute Engine VM Instance (google_compute_instance).

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-vm"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = "default"

    access_config {
      # attaches an external IP
    }
  }

  service_account {
    email  = var.service_account_email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  metadata = {
    ssh-keys = "terraform:${file("~/.ssh/id_rsa.pub")}"
  }
}

🔑 Concepts Learned

variables.tf vs terraform.tfvars

variables.tf → declares variables (name + type + description).

terraform.tfvars → assigns actual values (like config file).

Separation = reusable infra (different envs → different .tfvars).

Network & access_config

access_config = attaches an external (public) IP.

If removed → VM only gets private IP (good for private setups).

Variations:

access_config {} = ephemeral public IP.

nat_ip = "X.X.X.X" inside it → static reserved IP.

Service Account + Scopes

VM runs under a service account (identity).

scopes = permissions (what API access it has).

https://www.googleapis.com/auth/cloud-platform → full access to all enabled APIs.

Metadata → SSH Keys

Injects public SSH key (id_rsa.pub) into VM metadata.

Allows login as user (terraform) with private key.

Alternative → OS Login or IAM roles.

SSH Key Flow

Generate key: ssh-keygen -t rsa -f ~/.ssh/id_rsa -C terraform.

Public key → VM metadata.

Private key → used to login:

ssh -i ~/.ssh/id_rsa terraform@<EXTERNAL_IP>


Enabled Compute Engine API

Error was due to API not enabled.

Enabled via console or gcloud services enable compute.googleapis.com.
===========================================================
Concepts:

VM instance → Virtual machine hosted in GCP Compute Engine.

Boot disk → Defines OS image (Debian, Ubuntu, etc.).

Service accounts → Provide VMs identity & permissions for accessing GCP services.

Scopes → OAuth2 permissions assigned to VMs.

Metadata:

Inject SSH keys → Allow secure login.

Can also store custom key-value pairs for apps.

Commands for SSH:

ssh -i ~/.ssh/id_rsa terraform@<vm_public_ip>


Interview Pointers:

Q: Why add SSH keys in metadata?
A: Lets you securely log in without password. Public key is added to VM, private key stays with user.

Q: Why add service account & scopes?
A: VMs need identity to call APIs (e.g., Cloud Storage, Pub/Sub). Scopes restrict what the VM can do.

Q: Difference between variables.tf and terraform.tfvars?

variables.tf → Declaration (placeholders).

terraform.tfvars → Actual values.