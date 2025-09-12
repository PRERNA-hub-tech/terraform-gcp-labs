variable "project_id" {
  type = string

}
variable "region" {
  type = string
  default = "us-central1"
}
variable "zone" {
  type = string
  default = "us-central1-a"
}
variable "vm_count" {
  type = number
  default = 2
}