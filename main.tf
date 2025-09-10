provider "google" {
  project = var.project_id
  region= var.region
}
resource "google_storage_bucket" "demo_bucket" {
  name = "terraform-demo-bucket-${random_id.bucket_id.hex}"
  location = var.region
}
resource "random_id" "bucket_id" {
 byte_length = 4 
}