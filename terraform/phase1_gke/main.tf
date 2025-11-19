provider "google" {
  project = var.project_id
  region  = var.region
}

module "gke_cluster" {
  source       = "./modules/gke_cluster"
  project_id   = var.project_id
  region       = var.region
  cluster_name = var.cluster_name
}

module "gcs" {
  source             = "./modules/gcs"
  bucket_name_prefix = "urcloudoptimize"
  location           = "asia-south2"
}
