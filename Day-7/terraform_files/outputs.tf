output "cloud_run_url" {
  description = "The URL to access the deployed Cloud Run service"
  value       = google_cloud_run_service.todo_service.status[0].url
}

