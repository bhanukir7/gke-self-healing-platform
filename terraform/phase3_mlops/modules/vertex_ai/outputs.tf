output "tensorboard_id" {
  value = google_vertex_ai_tensorboard.tensorboard.id
}

output "training_pipeline_id" {
  value = google_vertex_ai_training_pipeline.training_pipeline.id
}

output "endpoint_id" {
  value = google_vertex_ai_endpoint.endpoint.id
}
