resource "google_monitoring_alert_policy" "gke_cpu_utilization" {
  project      = var.project_id
  display_name = "GKE High CPU Utilization"
  combiner     = "OR"

  conditions {
    display_name = "CPU usage is above 80% for 5 minutes"

    condition_threshold {
      filter          = "metric.type=\"kubernetes.io/container/cpu/core_usage_time\" AND resource.labels.cluster_name=\""-var.gke_cluster_name-"\""
      duration        = "300s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0.8

      trigger {
        count = 1
      }

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }

  notification_channels = [
    google_monitoring_notification_channel.pubsub.name,
  ]
}

resource "google_pubsub_topic" "self_healing" {
  project = var.project_id
  name    = "gke-self-healing-notifications"
}

resource "google_monitoring_notification_channel" "pubsub" {
  project      = var.project_id
  display_name = "GKE Self-Healing Pub/Sub"
  type         = "pubsub"
  labels = {
    topic = google_pubsub_topic.self_healing.name
  }
}

resource "google_cloud_run_v2_service" "self_healing_service" {
  project  = var.project_id
  name     = "self-healing-service"
  location = var.region

  template {
    containers {
      image = "gcr.io/${var.project_id}/self-healing-service:latest"
    }
  }
  depends_on = [google_cloudbuild_trigger.self_healing_service_builder]
}

resource "google_cloud_run_service_iam_binding" "allow_unauthenticated" {
  project  = google_cloud_run_v2_service.self_healing_service.project
  location = google_cloud_run_v2_service.self_healing_service.location
  service  = google_cloud_run_v2_service.self_healing_service.name
  role     = "roles/run.invoker"
  members = [
    "allUsers",
  ]
}

resource "google_pubsub_subscription" "subscription" {
  project = var.project_id
  name    = "gke-self-healing-subscription"
  topic   = google_pubsub_topic.self_healing.name

  push_config {
    push_endpoint = google_cloud_run_v2_service.self_healing_service.uri
  }
}

resource "google_cloudbuild_trigger" "self_healing_service_builder" {
  project = var.project_id
  name    = "self-healing-service-builder"
  location = var.region

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      branch = "^main$"
    }
  }

  included_files = ["use_cases/gke_monitoring_and_healing/src/self_healing_service/**"]

  filename = "use_cases/gke_monitoring_and_healing/src/self_healing_service/cloudbuild.yaml"
}

data "google_project" "project" {}

resource "google_project_iam_member" "cloudbuild_gcr" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

resource "google_project_iam_member" "cloudbuild_sa_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}
