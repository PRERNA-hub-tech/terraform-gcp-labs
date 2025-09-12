variable "project" {
  description = "Project ID"
  type = string
  
}
variable "region" {
  default = "us-central1"
  description = "GCP region"
  type = string
}
variable "zone" {
  description = "GCP zone"
  type = string
  default = "us-centra1-a"
}