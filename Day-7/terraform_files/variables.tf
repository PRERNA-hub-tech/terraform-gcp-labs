variable "project_id" {
  type = string
}
variable "region" {
  type = string
}
variable "image_version" {
  description = "The version tag for the container image"
  type        = string
  default     = "v1"

}
