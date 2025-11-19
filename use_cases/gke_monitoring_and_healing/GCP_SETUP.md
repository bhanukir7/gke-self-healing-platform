# GCP Setup for GKE Self-Healing with GitHub Actions

This document provides a step-by-step guide to setting up the necessary Google Cloud Platform resources and configuring a GitHub Actions workflow to deploy the GKE self-healing system.

## 1. Prerequisites

*   A Google Cloud project with billing enabled.
*   A GKE cluster already provisioned.
*   A GitHub repository containing the Terraform code and application source code.
*   The `gcloud` CLI installed and authenticated to your Google Cloud project.

## 2. Google Cloud Setup

### 2.1 Enable Required APIs

First, enable all the necessary APIs for the project:

```bash
gcloud services enable \
  compute.googleapis.com \
  container.googleapis.com \
  monitoring.googleapis.com \
  pubsub.googleapis.com \
  run.googleapis.com \
  cloudbuild.googleapis.com
```

### 2.2 Create a Service Account for GitHub Actions

Create a dedicated service account that GitHub Actions will use to authenticate with Google Cloud.

```bash
export GITHUB_SA_NAME="github-actions-sa"
gcloud iam service-accounts create $GITHUB_SA_NAME \
  --display-name="GitHub Actions Service Account"
```

### 2.3 Assign Roles to the Service Account

Grant the service account the necessary permissions to manage the resources defined in the Terraform configuration.

```bash
export PROJECT_ID=$(gcloud config get-value project)
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$GITHUB_SA_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/editor" # For simplicity, but can be more granular
```

**Note:** Using the `editor` role is permissive. In a production environment, you should create a custom IAM role with only the permissions required by the Terraform configuration.

### 2.4 Create a Service Account Key

Generate a JSON key for the service account. This key will be used to authenticate from the GitHub Actions workflow.

```bash
gcloud iam service-accounts keys create github-actions-key.json \
  --iam-account="$GITHUB_SA_NAME@$PROJECT_ID.iam.gserviceaccount.com"
```

**Important:** This `github-actions-key.json` file contains sensitive credentials. Do not commit it to your Git repository.

## 3. GitHub Setup

### 3.1 Configure Repository Secrets

In your GitHub repository, go to `Settings` > `Secrets and variables` > `Actions` and add the following secrets:

*   `GCP_PROJECT_ID`: Your Google Cloud project ID.
*   `GCP_SA_KEY`: The base64-encoded content of the `github-actions-key.json` file. You can encode it with the following command:

    ```bash
    cat github-actions-key.json | base64 -w 0
    ```

### 3.2 Create the GitHub Actions Workflow

Create a `.github/workflows/deploy.yml` file in your repository with the following content:

```yaml
name: Deploy to GCP

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Authenticate to Google Cloud
        uses: google-github-actions/auth@v1
        with:
          credentials_json: ${{ secrets.GCP_SA_KEY }}

      - name: Set up Cloud SDK
        uses: google-github-actions/setup-gcloud@v1

      - name: Configure Terraform
        uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: 1.2.0

      - name: Terraform Init
        run: terraform init
        working-directory: ./terraform # Adjust if your terraform root is elsewhere

      - name: Terraform Apply
        run: terraform apply -auto-approve -var="project_id=${{ secrets.GCP_PROJECT_ID }}" -var="github_owner=${{ github.repository_owner }}" -var="github_repo_name=${{ github.event.repository.name }}"
        working-directory: ./terraform # Adjust if your terraform root is elsewhere
```

## 4. Deployment

With the service account, secrets, and workflow in place, any push to the `main` branch of your repository will trigger the GitHub Actions workflow. The workflow will authenticate to Google Cloud and use Terraform to apply the configuration, deploying or updating all the necessary resources.

## 5. Post-Deployment

After the initial deployment, you need to connect your Google Cloud project to your GitHub repository to enable the Cloud Build trigger. You can find instructions on how to do this in the [Cloud Build documentation](https://cloud.google.com/build/docs/automating-builds/create-github-app-triggers).

This one-time manual step is necessary to grant Cloud Build access to your source code repository.
