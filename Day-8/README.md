# Day 8 – Cloud SQL with Terraform (Postgres)

## 📌 Overview
In this day, we provisioned a **Cloud SQL (PostgreSQL) instance** using Terraform, created a database, user, and connected it to our application.  

---

## 🛠️ Steps

### 1. Enable Required APIs
```bash
gcloud services enable sqladmin.googleapis.com
2. Terraform Code
main.tf
hcl
Copy code
provider "google" {
  project = var.project_id
  region  = var.region
}

# Cloud SQL Instance
resource "google_sql_database_instance" "db_instance" {
  name             = "todo-db"
  database_version = "POSTGRES_14"
  region           = var.region

  settings {
    tier = "db-f1-micro"   # Free-tier eligible
    ip_configuration {
      ipv4_enabled    = true
      authorized_networks {
        value = "YOUR_PUBLIC_IP/32"   # Add your client IP
      }
    }
  }
}

# Database
resource "google_sql_database" "todo_db" {
  name     = "todo"
  instance = google_sql_database_instance.db_instance.name
}

# User
resource "google_sql_user" "todo_user" {
  name     = "todo_user"
  instance = google_sql_database_instance.db_instance.name
  password = "StrongPass123!"
}
variables.tf

variable "project_id" {}
variable "region" {
  default = "us-central1"
}
terraform.tfvars

project_id = "your-project-id"
3. Deploy with Terraform

terraform init
terraform apply -auto-approve
4. Get DB Connection Info

gcloud sql instances describe todo-db
Copy the Public IP.

5. Connect to Database

psql -h <PUBLIC_IP> -U todo_user -d todo
6. Useful SQL Commands

\l      -- list databases
\dt     -- list tables
\du     -- list users
✅ Key Notes
Public IP + Authorized Networks used for connection.

Private IP + SQL Proxy recommended for production.

terraform destroy will delete the DB instance, users, and DB.

Instance class: db-f1-micro (free tier eligible).