# Architecture: GKE Self-Healing System

This document outlines the architecture for the automated GKE monitoring and self-healing system. The primary goal is to detect issues within the GKE cluster, such as high resource utilization, and automatically trigger a response to mitigate the issue without manual intervention.

## System Components

The system is composed of several serverless Google Cloud components, orchestrated by Terraform for infrastructure as code.

1.  **Cloud Monitoring:** An Alert Policy is configured to continuously monitor the CPU utilization of containers within the specified GKE cluster.
2.  **Pub/Sub:** A Pub/Sub topic acts as the messaging backbone. When the Cloud Monitoring alert is triggered, it sends a notification message to this topic.
3.  **Cloud Run Service:** A containerized Python application deployed as a serverless Cloud Run service. It exposes an HTTP endpoint and is subscribed to the Pub/Sub topic. This service houses the "healing" logic.
4.  **Cloud Build:** A CI/CD pipeline that automatically builds the Docker image for the self-healing service from source and pushes it to the Google Container Registry (GCR).
5.  **Cloud Build Trigger:** A trigger that initiates the Cloud Build pipeline whenever changes are pushed to the main branch of the connected GitHub repository, specifically within the service's source code directory.

## Workflow

The self-healing process follows a reactive, event-driven workflow:

1.  **Detection:** The Cloud Monitoring alert policy detects that a container's CPU usage has exceeded 80% for more than 5 minutes.
2.  **Notification:** Once the alert's condition is met, it fires and publishes a JSON message containing details about the incident to the `gke-self-healing-notifications` Pub/Sub topic.
3.  **Invocation:** Pub/Sub has a push subscription configured to the Cloud Run service's endpoint. It immediately forwards the message to the service.
4.  **Execution:** The Cloud Run service receives the alert data. In its initial version, it parses the data and logs a message indicating that a healing action would be triggered. In a production scenario, this service would be enhanced to perform an actual remediation step, such as:
    *   Restarting the identified pod using the Kubernetes API.
    *   Scaling the deployment.
    *   Notifying a designated on-call engineer via a separate channel.
5.  **Automated Deployment:** Any changes to the self-healing service's Python code or Dockerfile are automatically built and deployed by the Cloud Build trigger, ensuring the service is always up-to-date.

## Diagram

```
[GKE Cluster] -> (High CPU) -> [Cloud Monitoring Alert]
      |
      v
[Pub/Sub Topic: gke-self-healing-notifications]
      |
      v
[Pub/Sub Subscription] -> (HTTP POST) -> [Cloud Run: self-healing-service]
      |                                        |
      |<---------------------------------------(Logs action)
      |
[GitHub Repo] -> (git push) -> [Cloud Build Trigger] -> [Cloud Build] -> [GCR]
                                                        (Builds & Deploys)  ^
                                                                          |
                                                      [Cloud Run] <-----(Pulls image)
```
