output "cluster_name" {
  description = "The name of the GKE cluster."
  value       = module.gke_cluster.cluster_name
}

output "cluster_endpoint" {
  description = "The endpoint of the GKE cluster."
  value       = module.gke_cluster.cluster_endpoint
}

output "gcs_bucket_name" {
  value = module.gcs.bucket_name
}

output "gcs_bucket_url" {
  value = module.gcs.bucket_url
}