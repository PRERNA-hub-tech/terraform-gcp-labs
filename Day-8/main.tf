provider "google" {
  project = var.project_id
  region = var.region
}

resource "google_sql_database_instance" "db_instance" {
  name = "todo-db"
  region = var.region
  database_version = "POSTGRES_14"
  deletion_protection = false
  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled = true
      authorized_networks {
        name = "home"
        value = "0.0.0.0/0"
      }
    }
  }
}

resource "google_sql_database" "db" {
  name = "todoapp"
  instance = google_sql_database_instance.db_instance.name
  
}

resource "google_sql_user" "users" {
  name = "todo_user"
  instance = google_sql_database_instance.db_instance.name
  password = "todo_pass123"
}
output "db_public_ip" {
  value = google_sql_database_instance.db_instance.public_ip_address
}


