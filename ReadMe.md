# Repository Structure

This repository is organized as follows:

```plaintext
.
├── apps/
│   ├── qualgo-backend
│   │   └──------------ sources
│   │   └──------------ ReadMe.md
│   ├── qualgo-frontend
│   │   └──------------ sources
│   │   └──------------ ReadMe.md
│   └── qualgo-migrations
├── deploy
│   ├── autotests/
│   └── charts/
│   │   └──------------ qualgo-apps
│   │   │──------------ └--------------------ReadMe.md
│   │   └──------------ cluster-autoscaler
│   │   └──------------ ingress-nginx
│   │   └──------------ metrics-server
│   │   └──------------ trivy-operator
│   └── ReadMe.md
├── docs/
│   ├── diagram
├── terraform/
│   ├── module/
│   │   └──------------ apigateway
│   │   └──------------ ecr
│   │   └──------------ eks
│   │   └──------------ iam
│   │   └──------------ rds-mysql
│   │   └──------------ sg
│   │   └──------------ vpc
│   └── main.tf
│   └── backend.tf
│   └── output.tf
│   └── variables.tf
│   └── ReadMe.md
├── README.md
├── Jenkinsfile

```

# Requirements:
✅ Use a version control system (e.g., Git) to manage your codebase.

    Using GitHub to store everything, including application codebases, infrastructure as code, database migrations, deployment scripts, Jenkinsfiles, and more

✅ Utilize a container orchestration tool (e.g., Kubernetes, Docker Swarm) for managing the containerized infrastructure.

    Managing the containerized infrastructure in EKS

✅ Implement infrastructure provisioning using a cloud provider of your choice (e.g., AWS, Azure, GCP) or a local virtualization tool (e.g., Minikube, Docker Desktop).

    Using AWS as the cloud provider, with components such as API Gateway, EKS, EC2, Security Groups, Load Balancers, S3, RDS, and more.

✅ Ensure the solution is modular, scalable, and easily configurable for different levels of load and traffic.

    Using Terraform modules with varying inputs.

✅ Include appropriate security measures in your containerized infrastructure setup.

    Using trivy-operator to detect security measures

✅ Implement auto-scaling capabilities for handling increased demand on the web application.

    Auto-scaling Kubernetes nodes with Cluster Autoscaler and auto-scaling pods with HPA

✅ Use best practices for containerization, including Dockerfile optimization and container image management.

    The Dockerfile for each application has already been optimized. Check at [backend](apps/qualgo-backend), [frontend](apps/qualgo-frontend)

✅ Ensure proper networking setup for communication between containers and external traffic.

    I have applied network policies and security group configurations to handle communication between containers and AWS resources.
    Refer to [qualgo-apps](deploy/charts/qualgo-apps/templates/)

✅ Use Infrastructure as Code principles for managing container configurations and deployments.

    All Terraform modules and configurations are stored in GitHub

# Deliverables
✅ Small demo [qualgo-app](apps/) to list students from database

✅ Diagram infrastructure [diagram](docs/qualgo-tech.drawio.png)

✅ Infrastructure as code [terraform](terraform)

✅ CICD [diagram](docs/qualgo-tech.drawio.png)

✅ Database migrations automatically [migration](apps/qualgo-migrations)

✅ Canary Deployment with 30% weight

✅ Control connection between services

✅ Auto scale infrastructure and services

