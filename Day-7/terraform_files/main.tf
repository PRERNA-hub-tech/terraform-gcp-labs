provider "google" {
  project = "fourth-castle-471604-t0"
  region  = "us-central1"
}

resource "google_cloud_run_service" "todo_service" {
  name     = "todo-service"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "us-central1-docker.pkg.dev/fourth-castle-471604-t0/todo-app-repo/todo-app:${var.image_version}"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "all_users" {
  location = google_cloud_run_service.todo_service.location
  service  = google_cloud_run_service.todo_service.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
