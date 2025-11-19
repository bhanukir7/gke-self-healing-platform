# Google Cloud Groundwork for Terraform Deployment

This document outlines the essential steps to prepare your Google Cloud Platform (GCP) project before deploying the Terraform infrastructure. Following these steps ensures that Terraform has the necessary permissions and that all required services are enabled.

## 1. Prerequisites

- You have a Google Cloud account with a project created.
- You have a billing account linked to your project.
- You have the `gcloud` command-line tool installed and authenticated (`gcloud auth login`).

## 2. Set Project Configuration

First, set your project ID and a desired region in your local environment to streamline the following commands.

```bash
export PROJECT_ID="your-gcp-project-id"
export REGION="your-gcp-region" # e.g., us-central1

gcloud config set project $PROJECT_ID
```
**Note:** Replace `your-gcp-project-id` and `your-gcp-region` with your actual project details.

## 3. Create a Service Account

It is a best practice to use a dedicated service account for Terraform to provide a clear audit trail and limit permissions.

```bash
export TF_SERVICE_ACCOUNT="terraform-executor"

gcloud iam service-accounts create $TF_SERVICE_ACCOUNT \
  --display-name="Terraform Executor"
```

## 4. Grant Permissions

The service account needs permissions to create and manage resources. For simplicity, we will grant the `Editor` role. For production environments, you should follow the principle of least privilege and grant more granular roles.

```bash
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$TF_SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/editor"
```

## 5. Enable Required APIs

Terraform can only provision resources for APIs that are enabled. The following command enables all APIs required for this project's four phases.

```bash
gcloud services enable \
  container.googleapis.com \
  bigquery.googleapis.com \
  pubsub.googleapis.com \
  dataflow.googleapis.com \
  aiplatform.googleapis.com \
  run.googleapis.com \
  cloudbuild.googleapis.com \
  iam.googleapis.com \
  cloudresourcemanager.googleapis.com
```

## 6. Create a GCS Bucket for Terraform State

Storing your Terraform state file remotely in a GCS bucket is crucial for collaboration and preventing state loss.

```bash
export TF_STATE_BUCKET="${PROJECT_ID}-tf-state"

# Note: GCS bucket names must be globally unique.
gcloud storage buckets create gs://$TF_STATE_BUCKET --location=$REGION
```

## 7. Configure Terraform Backend

Now, instruct Terraform to use the GCS bucket you just created for its state backend. Add the following block to your `terraform/main.tf` file:

```hcl
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
```

## 8. Set Up Authentication for Terraform

Finally, create a key for the service account and tell Terraform how to use it by setting an environment variable.

```bash
# Create and download the key file
gcloud iam service-accounts keys create ./terraform-credentials.json \
  --iam-account="$TF_SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com"

# Set the environment variable for the current session
export GOOGLE_APPLICATION_CREDENTIALS="$(pwd)/terraform-credentials.json"
```

After completing these steps, you can run `terraform init` and `terraform apply` from the `terraform` directory to deploy your infrastructure.
