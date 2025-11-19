resource "google_bigquery_dataset" "dataset" {
  dataset_id = "${var.dataset_id_prefix}_finops_mlops_dataset"
  location   = var.location
}
