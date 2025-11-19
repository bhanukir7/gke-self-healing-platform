terraform {
  backend "gcs" {
    bucket  = "your-project-id-tf-state" # <-- IMPORTANT: Use the bucket name from the previous step
    prefix  = "terraform/state"
  }
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

module "phase1_gke" {
  source     = "./phase1_gke"
  project_id = var.project_id
  region     = var.region
}

module "phase2_dataops" {
  source     = "./phase2_dataops"
  project_id = var.project_id
  region     = var.region
}

module "phase3_mlops" {
  source     = "./phase3_mlops"
  project_id = var.project_id
  region     = var.region
}

module "phase4_chatops" {
  source     = "./phase4_chatops"
  project_id = var.project_id
  region     = var.region
}

module "gke_monitoring_and_healing" {
  source           = "./use_cases/gke_monitoring_and_healing/terraform"
  project_id       = var.project_id
  region           = var.region
  gke_cluster_name = module.phase1_gke.cluster_name
}
