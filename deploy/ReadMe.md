There are two scripts: one to install the required charts for the infrastructure and the other to install the Qualgo applications, including the backend and frontend.

- run `bash deploy-infra.sh` to install required charts for infrastructure like `ingress-nginx`, `metrics-server`, `cluster-autoscaler`, `trivy-operator`

- run `bash deploy-apps.sh` to install qualgo applications. Note that CI will use this script to upgrade our applications
