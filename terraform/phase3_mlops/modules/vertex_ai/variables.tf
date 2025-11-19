variable "tensorboard_display_name" {
  description = "The display name of the Vertex AI Tensorboard."
  type        = string
}

variable "region" {
  description = "The GCP region for the Vertex AI Tensorboard."
  type        = string
}

variable "pipeline_display_name" {
  description = "The display name of the Vertex AI Training Pipeline."
  type        = string
}

variable "model_display_name" {
  description = "The display name of the model to be uploaded."
  type        = string
}

variable "endpoint_display_name" {
  description = "The display name of the Vertex AI Endpoint."
  type        = string
}
