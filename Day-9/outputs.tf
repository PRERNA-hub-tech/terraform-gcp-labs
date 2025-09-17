
output "pubsub_topic_name" {
  description = "The Pub/Sub topic name"
  value       = google_pubsub_topic.todo_topic.name
}

output "cloud_function_name" {
  description = "The Cloud Function name"
  value       = google_cloudfunctions_function.todo_function.name
}

output "cloud_function_url" {
  description = "The Cloud Function HTTPS URL"
  value       = google_cloudfunctions_function.todo_function.https_trigger_url
}
