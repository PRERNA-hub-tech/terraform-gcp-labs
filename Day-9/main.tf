terraform {
  required_providers {
    google ={
        source = "hashicorp/google"

    }
  }
}

provider "google" {
  project = var.project_id
  region = var.region
}

# Pub Sub topic

resource "google_pubsub_topic" "todo_topic" {
  name = "todo-topic"
}

# Cloud Function

resource "google_storage_bucket" "bucket" {
  name = "${var.project_id}-functions"
  location = var.region
  force_destroy = true
}

resource "google_storage_bucket_object" "function_zip" {
  name = "function-source.zip"
  bucket = google_storage_bucket.bucket.name
  source = "function-source.zip"
}

resource "google_cloudfunctions_function" "todo_function" {
  name = "todo-function"
  description = "Triggered by Pub/Sub message"
  runtime = "python310"
  available_memory_mb = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.function_zip.name
  entry_point = "pubsub_handler"
  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource = google_pubsub_topic.todo_topic.name

}
}
resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.todo_function.project
  region         = google_cloudfunctions_function.todo_function.region
  cloud_function = google_cloudfunctions_function.todo_function.name

  role   = "roles/cloudfunctions.invoker"
  member = "serviceAccount:${google_cloudfunctions_function.todo_function.service_account_email}"
}

