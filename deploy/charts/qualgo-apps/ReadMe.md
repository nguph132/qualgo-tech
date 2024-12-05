# Kubernetes Deployment for Qualgo Applications

This repository contains the deployment configuration for three services: frontend, backend, and canary for backend services. The Kubernetes resources implemented include `Deployment`, `HorizontalPodAutoscaler (HPA)`, `Ingress`, `NetworkPolicy`, `ServiceAccount`, `Service`, and `PodDisruptionBudget`.

## Services Overview

We are deploying the following services:
- **Frontend**: The frontend service that interacts with the backend API.
- **Backend**: The main backend service providing the core API.
- **Canary**: A canary backend service for testing new features and rolling updates.

## Kubernetes Resources

The following Kubernetes resources are defined for each service:

### 1. **Deployment**

Each service is deployed with a `Deployment` resource. Key configurations include:

- **Readiness & Liveness Probes**: Ensures the application is healthy and ready to serve traffic.
- **Pod Security Context**: Defines pod-level security settings, including user and group IDs.
- **Container Security Context**: Defines security settings for containers like running as non-root user.
- **Service Account**: The services do not use the default service account, and a custom service account is assigned.
- **Topology Spread Constraints**: Distributes pods across different zones to improve availability.
- **Affinity**: Defines rules to influence pod placement for better resource allocation and isolation.
- **Resource Requests and Limits**: Defines CPU and memory resources to ensure efficient resource utilization and scale