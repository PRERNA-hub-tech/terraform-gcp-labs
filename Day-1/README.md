📒 Day 1 – Terraform Setup & GCS Bucket
🛠️ Setup

Installed Terraform and added it to PATH.

Configured Google Cloud SDK (gcloud) and authenticated.

Created project & set Project ID.

Linked billing account.

Configured credentials for Terraform.

Removed stale env variables (GOOGLE_APPLICATION_CREDENTIALS).

Used Application Default Credentials (ADC) → gcloud auth application-default login.

📂 Files

main.tf → Terraform configuration.

.gitignore → ignored terraform.tfstate, .terraform/, and sensitive files.

Committed to GitHub repo for tracking labs.

📦 Resource Created

Google Cloud Storage bucket (google_storage_bucket).

resource "google_storage_bucket" "demo_bucket" {
  name     = "my-demo-tf-bucket"
  location = "US"
}

🔑 Concepts Learned

Terraform Workflow:

terraform init → downloads providers.

terraform plan → preview infra changes.

terraform apply → create/update infra.

terraform destroy → delete infra.

State File (terraform.tfstate):

Tracks real resources ↔ Terraform config.

Must be stored securely (local now, remote in real teams).

Provider Block: connects Terraform to GCP with project + region.
===================================
Concepts:

Terraform → Infrastructure as Code (IaC) tool to provision/manage cloud infra.

Providers → Plugins (e.g., google, aws) that let Terraform talk to cloud APIs.

Resources → Individual infra components (google_storage_bucket, google_compute_instance).

Terraform workflow:

terraform init → Initialize provider plugins.

terraform plan → Preview changes.

terraform apply → Create/update infra.

terraform destroy → Remove infra.

Key files:

main.tf → Resource definitions.

variables.tf → Declares variables.

terraform.tfvars → Values for variables.

.gitignore → Ignore terraform.tfstate (sensitive).

Interview Pointers:

Q: What is Terraform State?
A: File (terraform.tfstate) that tracks resource mappings between code & real infra. Needed to know what to create/destroy/update.

Q: Why ignore state files in Git?
A: State contains sensitive info (keys, IPs, secrets). Should be stored in secure remote backend (e.g., GCS bucket, S3).