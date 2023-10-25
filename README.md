# project-root
Folder and file structure for microservice architecture in GCP and Terraform usage
microservices/: This folder contains directories for each microservice. Each microservice directory contains source code (such as main.go), a Docker file for containerization, and other files specific to the microservice.

terraform/: This folder contains Terraform configuration files for building and managing infrastructure in GCP. The files main.tf, variables.tf, and outputs.tf are used to describe and configure resources, and the terraform.tfvars file contains configuration variables.

kubernetes/: Kubernetes manifests for deploying microservices in a Kubernetes cluster can be placed here. Each manifest (e.g. deployment.yaml and service.yaml) describes the deployment and service of the corresponding microservice.

config/: This folder contains the configuration files for each microservice. These files can include settings, secrets, and parameters that the microservices use to operate.

scripts/: Various scripts can be placed here to automate the deployment, destruction, and management of infrastructure and microservices.

