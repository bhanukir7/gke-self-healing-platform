# Project Plan: GKE Self-Healing

This document outlines the phased plan to implement the GKE monitoring and self-healing use case. We will follow this plan to incrementally build and test the solution.

## Project Goal

To create a modular and automated system that monitors GKE cluster health, uses a placeholder machine learning model to detect anomalies (initially high CPU), triggers a self-healing action via a Cloud Run service, and notifies a designated chat channel about the actions taken.

## Phased Plan

### Phase 1: Monitoring & Alerting Foundation

*   **Goal:** Establish the basic monitoring and alerting mechanism.
*   **Tasks:**
    *   **1.1:** Define Terraform resources for a Cloud Monitoring alerting policy. This policy will trigger on high CPU utilization.
    *   **1.2:** Create a Pub/Sub topic that will receive notifications from the alerting policy.
    *   **1.3:** Create a Terraform module for the self-healing use case and invoke it from the root `main.tf` file.

### Phase 2: Self-Healing Service (Initial Version)

*   **Goal:** Develop a service that can be triggered by the alert and perform a basic action.
*   **Tasks:**
    *   **2.1:** Develop a basic Cloud Run service in Python within `src/self_healing_service/`.
    *   **2.2:** The service will be triggered by messages on the Pub/Sub topic from Phase 1.
    *   **2.3:** Implement logic to parse the alert and log a message like "Healing action would be triggered for [pod name]".
    *   **2.4:** Define Terraform resources to build and deploy this Cloud Run service.

### Phase 3: Implementing the Healing Logic

*   **Goal:** Grant the service the ability to perform a real corrective action.
*   **Tasks:**
    *   **3.1:** Grant the Self-Healing Service account the necessary IAM permissions to manage GKE pods.
    *   **3.2:** Implement the logic in the service to interact with the GKE API and restart a deployment identified in the alert.

### Phase 4: ChatOps Integration & End-to-End Test

*   **Goal:** Integrate the healing process with our existing ChatOps service for notifications.
*   **Tasks:**
    *   **4.1:** Extend the Self-Healing Service to make an API call to the `phase4_chatops` service.
    *   **4.2:** The notification message should include details about the detected issue and the corrective action taken.
    *   **4.3:** Conduct an end-to-end test by inducing high CPU on a test pod and verifying the entire automated flow.

## Action Tracker

| Task ID | Description                                        | Assignee | Due Date   | Status      |
| :------ | :------------------------------------------------- | :------- | :--------- | :---------- |
| 1.1     | Create Terraform for Monitoring Alert Policy       | Gemini   |            | In Progress |
| 1.2     | Create Terraform for Pub/Sub Notification Topic    | Gemini   |            | Not Started |
| 1.3     | Create and invoke the Terraform module             |          |            | Not Started |
| 2.1     | Develop basic Cloud Run service                    |          |            | Not Started |
| 2.2     | Implement Pub/Sub trigger for the service          |          |            | Not Started |
| 2.3     | Implement logging of the healing action            |          |            | Not Started |
| 2.4     | Create Terraform for the service deployment        |          |            | Not Started |
| 3.1     | Grant IAM permissions for GKE actions              |          |            | Not Started |
| 3.2     | Implement GKE deployment restart logic             |          |            | Not Started |
| 4.1     | Integrate with ChatOps service for notifications   |          |            | Not Started |
| 4.2     | Send detailed notification messages                |          |            | Not Started |
| 4.3     | Perform end-to-end system test                     |          |            | Not Started |

