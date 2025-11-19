variable "project_id" {
  description = "The ID of the Google Cloud project."
  type        = string
}

variable "region" {
  description = "The region for the resources."
  type        = string
}

variable "gke_cluster_name" {
  description = "The name of the GKE cluster to monitor."
  type        = string
}

variable "github_owner" {
  description = "The owner of the GitHub repository."
  type        = string
}

variable "github_repo_name" {
  description = "The name of the GitHub repository."
  type        = string
}
