# Cloud FinOps and MLOps Project

This project provides a comprehensive solution for managing cloud costs and implementing MLOps on Google Cloud Platform (GCP).

## Project Documentation

This project is documented across several files. For a complete understanding of the project, please review the following documents:

*   **[ARCHITECTURE.md](ARCHITECTURE.md)**: Provides a high-level overview of the system design and the interaction between the different components.
*   **[GCP_SETUP.md](GCP_SETUP.md)**: Outlines the necessary steps to configure your Google Cloud project before deploying the infrastructure.
*   **[terraform/README.md](terraform/README.md)**: Details the Infrastructure as Code (IaC) setup for the four phases of the project.
*   **[use_cases/gke_monitoring_and_healing/README.md](use_cases/gke_monitoring_and_healing/README.md)**: Describes the specific use case for monitoring a GKE cluster and implementing a self-healing mechanism.

## Project Structure

The project is organized into the following directories:

*   `/src`: Contains a sample Python Flask application that serves as a placeholder for the self-healing service logic.
*   `/terraform`: Contains the Terraform code for the project's infrastructure.
*   `/use_cases`: Contains documentation and code for specific use cases of the platform.

## Getting Started

### Prerequisites

*   Google Cloud SDK
*   Terraform
*   Python 3.8+

### Setup

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/your-username/your-repository.git
    cd your-repository
    ```

2.  **Authenticate with GCP:**

    ```bash
    gcloud auth application-default login
    ```

3.  **Initialize and apply Terraform:**

    Navigate to each Terraform phase directory (`/terraform/phase1_foundational`, `/terraform/phase2_dataops`, `/terraform/phase3_mlops`) and run:

    ```bash
    terraform init
    terraform apply
    ```

4.  **Install Python dependencies:**

    ```bash
    pip install -r src/requirements.txt
    ```

5.  **Run the application:**

    ```bash
    python src/main.py
    ```

## Usage

Provide instructions on how to use the application, including any available commands or endpoints.

## Contributing

Contributions are welcome! Please create a pull request with a detailed description of your changes.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more information.
