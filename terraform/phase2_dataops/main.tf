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

module "bigquery" {
  source            = "./modules/bigquery"
  dataset_id_prefix = "urcloudoptimize"
  location          = "asia-south2"
}

module "pubsub" {
  source     = "./modules/pubsub"
  topic_name = "finops-mlops-topic"
}

module "dataflow" {
  source = "./modules/dataflow"
  # Add variables for dataflow module here
}
