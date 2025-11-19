resource "google_storage_bucket" "bucket" {
  name          = "${var.bucket_name_prefix}-finops-mlops-bucket"
  location      = var.location
  force_destroy = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30
    }
  }
}
