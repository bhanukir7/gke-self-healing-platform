variable "service_name" {
  description = "The name of the Cloud Run service."
  type        = string
}

variable "region" {
  description = "The GCP region for the Cloud Run service."
  type        = string
}

variable "image_name" {
  description = "The name of the container image to deploy."
  type        = string
}
