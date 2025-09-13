output "website_url" {
  value = "https://storage.googleapis.com/${google_storage_bucket.static_site.name}/index.html"
}
output "load_balancer_ip" {
  description = "The external IP address of the HTTP Load Balancer"
  value       = google_compute_global_forwarding_rule.http_rule.ip_address
}