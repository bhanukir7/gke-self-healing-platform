resource "google_vertex_ai_tensorboard" "tensorboard" {
  display_name = var.tensorboard_display_name
  description  = "Tensorboard for MLOps"
  region       = var.region
}

resource "google_vertex_ai_training_pipeline" "training_pipeline" {
  display_name = var.pipeline_display_name
  region       = var.region

  model_to_upload {
    display_name = var.model_display_name
  }
}

resource "google_vertex_ai_endpoint" "endpoint" {
  display_name = var.endpoint_display_name
  region       = var.region
}
