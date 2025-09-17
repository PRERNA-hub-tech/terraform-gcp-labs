👇

📘 Day 9  Cloud Functions + Pub/Sub (Terraform)
🔹 Concept Recap

Cloud Pub/Sub = Fully managed messaging service → decouples systems using topics and subscriptions.

Cloud Function = Event-driven serverless compute → executes code in response to an event (e.g., Pub/Sub message).

Integration: Cloud Function subscribes to a Pub/Sub topic → whenever a message is published, function auto-triggers.

🔹 Terraform Resources Used

google_pubsub_topic

Creates Pub/Sub topic for publishing messages.

resource "google_pubsub_topic" "todo_topic" {
  name = "todo-topic"
}


google_storage_bucket + google_storage_bucket_object

Stores function source code (zip file).

resource "google_storage_bucket" "function_bucket" {
  name     = "todo-functions-bucket"
  location = "US"
}

resource "google_storage_bucket_object" "function_zip" {
  name   = "function-source.zip"
  bucket = google_storage_bucket.function_bucket.name
  source = "../function-source.zip"
}


google_cloudfunctions_function

Deploys the Cloud Function.

resource "google_cloudfunctions_function" "todo_function" {
  name                  = "todo-function"
  runtime               = "python39"
  entry_point           = "pubsub_handler"
  source_archive_bucket = google_storage_bucket.function_bucket.name
  source_archive_object = google_storage_bucket_object.function_zip.name
  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.todo_topic.name
  }
}

🔹 Cloud Function Code (Python Example)

main.py

import base64

def pubsub_handler(event, context):
    message = base64.b64decode(event['data']).decode('utf-8')
    print(f"Received Pub/Sub message: {message}")


requirements.txt

# Empty (no external dependencies needed)

🔹 Deployment Flow

Zip source:

Compress-Archive -Path main.py, requirements.txt -DestinationPath ../function-source.zip -Force


Run Terraform:

terraform init
terraform apply

🔹 Testing the Setup

Publish message:

gcloud pubsub topics publish todo-topic --message="Hello from Pub/Sub!"


Check logs:

gcloud functions logs read todo-function


→ Should see:

Received Pub/Sub message: Hello from Pub/Sub!

🔹 Interview Points

Cloud Functions scale automatically → pay-per-use.

Pub/Sub ensures at least once delivery → function may get duplicate events → code should be idempotent.

Terraform integration: Function code stored in GCS bucket → source_archive_bucket + source_archive_object.

Use Pub/Sub when decoupling microservices, handling async jobs, or event-driven architectures