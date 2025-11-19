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

module "vertex_ai" {
  source                   = "./modules/vertex_ai"
  tensorboard_display_name = "finops-mlops-tensorboard"
  region                   = var.region
  pipeline_display_name    = "finops-mlops-training-pipeline"
  model_display_name       = "finops-mlops-model"
  endpoint_display_name    = "finops-mlops-endpoint"
}
