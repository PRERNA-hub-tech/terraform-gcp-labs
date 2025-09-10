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