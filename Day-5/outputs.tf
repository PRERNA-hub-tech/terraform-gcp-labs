output "load_balancer_ip" {
  value = google_compute_global_forwarding_rule.default.ip_address
}
output "network_name" {
  value = google_compute_network.custom_vpc.name
}
output "subnet_name" {
  value = google_compute_subnetwork.custom_subnet.name
}
output "mig_name" {
  value = google_compute_instance_group_manager.web_mig.name
}