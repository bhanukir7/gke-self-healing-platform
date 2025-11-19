terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "cloud_run" {
  source       = "./modules/cloud_run"
  service_name = "finops-chatops-service"
  region       = var.region
  image_name   = "gcr.io/cloudrun/hello"
}
