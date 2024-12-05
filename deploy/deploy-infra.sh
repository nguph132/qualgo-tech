#!/bin/bash

export CLUSTER_NAME="qualgo-eks"
export AWS_REGION="ap-southeast-1"
export AWS_PROFILE="qualgo-ci"
export KUBECONFIG="./qualgo-eks"
export AWS_ACCOUNT="888577040857"

echo "Generating kubeconfig for EKS cluster: $CLUSTER_NAME in region: $AWS_REGION"
aws eks --region $AWS_REGION update-kubeconfig --name $CLUSTER_NAME

# Verify Helm is working
helm version

if [ $? -eq 0 ]; then
    echo "Helm is ready to use with the EKS cluster."
else
    echo "Failed to verify Helm installation."
    exit 1
fi

echo "Update public helm chart"
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo add autoscaler https://kubernetes.github.io/autoscaler
helm repo add aqua https://aquasecurity.github.io/helm-charts/
helm repo update

echo "Upgrading nginx-ingress using Helm..."
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx -f ./charts/ingress-nginx/values.yaml -n ingress-nginx --create-namespace

echo "Upgrading metrics-server"
helm upgrade --install metrics-server metrics-server/metrics-server -f ./charts/metrics-server/values.yaml -n metrics-server --create-namespace

echo "Upgrading cluster-autoscaler"
helm upgrade --install cluster-autoscaler autoscaler/cluster-autoscaler -f ./charts/cluster-autoscaler/values.yaml -n kube-system --create-namespace

echo "Upgrading trivy"
helm upgrade --install trivy-operator aqua/trivy-operator --version 0.1.5 -f ./charts/trivy-operator/values.yaml -n trivy --create-namespace
