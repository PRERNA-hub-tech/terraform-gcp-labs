Day 7 – Dockerized To-Do App Deployment on Cloud Run

Objective

Deploy a Dockerized To-Do application to Google Cloud Run using Terraform, leveraging Artifact Registry for storing container images and versioning for image management.

Folder Structure
Day-7/
│
├── main.tf             # Terraform configuration for Cloud Run, Artifact Registry, and outputs
├── variables.tf        # Variables definitions
├── terraform.tfvars    # Values for variables including project ID, region, image version
├── outputs.tf          # Terraform outputs (Cloud Run URL)
├── Dockerfile          # Dockerfile to build the To-Do app image
├── .dockerignore       # Files/folders to ignore during Docker build
└── README.md

Prerequisites

GCP Account with billing enabled

Terraform installed (v1.5+)

Docker installed (Docker Desktop for Windows)

GCP SDK (gcloud) installed and authenticated

A working Dockerized To-Do app

Steps
1. Authenticate with GCP
gcloud auth login
gcloud auth configure-docker LOCATION-docker.pkg.dev

2. Build Docker Image Locally
docker build -t todo-app:1.0 .

3. Tag Docker Image for Artifact Registry
docker tag todo-app:1.0 LOCATION-docker.pkg.dev/PROJECT_ID/REPO_NAME/todo-app:1.0

4. Push Docker Image to Artifact Registry
docker push LOCATION-docker.pkg.dev/PROJECT_ID/REPO_NAME/todo-app:1.0

5. Configure Terraform Variables

terraform.tfvars

project_id   = "your-gcp-project-id"
region       = "us-central1"
image_name   = "LOCATION-docker.pkg.dev/PROJECT_ID/REPO_NAME/todo-app:1.0"

6. Terraform Commands

Initialize Terraform

terraform init


Preview Changes

terraform plan


Apply Changes

terraform apply


View Outputs

terraform output
# Example: cloud_run_url = https://todo-service-xyz.a.run.app

7. Access Application

The deployed To-Do app URL will be available via Terraform output.

Visit the URL in a browser to verify the deployment.

Notes

Image Versioning: Update the image_name in terraform.tfvars to deploy new versions.

Cloud Run: Automatically manages scaling based on traffic; no need for VM management.

Terraform: Maintains the desired state of Cloud Run and Artifact Registry resources.

Manual Build & Push: We are currently doing manual Docker builds and pushes; CI/CD automation will come later.

Useful Commands

Check Cloud Run Service

gcloud run services describe todo-service --region=us-central1


Check Container Logs

gcloud logs read --project PROJECT_ID