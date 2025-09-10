variable "project_id" {
  
}
variable "region" {
  default = "us-central1"
}
variable "zone" {
  default = "us-central1-a"

}
variable "vpc_name" {
  default = "day3-custom-vpc"
}
variable "subnet_name" {
  default = "day3-subnet"

}
variable "firewall_name" {
  default = "day3-allow-ssh-http"

}
