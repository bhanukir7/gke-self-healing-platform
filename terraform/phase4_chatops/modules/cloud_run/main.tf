resource "google_cloud_run_v2_service" "chatops_service" {
  name     = var.service_name
  location = var.region

  template {
    containers {
      image = var.image_name
    }
  }
}
