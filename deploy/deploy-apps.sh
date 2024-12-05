#!/bin/bash

export CLUSTER_NAME="qualgo-eks"
export AWS_REGION="ap-southeast-1"
export AWS_PROFILE="qualgo-ci"
export KUBECONFIG="./qualgo-eks"
export APP_NAMESPACE="qualgo"
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

echo "Install app"
kubectl create namespace $APP_NAMESPACE || true
kubectl delete secret ecr-secret -n $APP_NAMESPACE || true
kubectl create secret docker-registry ecr-secret \
  --docker-server=${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com \
  --docker-username=AWS \
  --docker-password=$(aws ecr get-login-password) \
  --namespace=$APP_NAMESPACE

helm upgrade --install qualgo ./charts/qualgo-apps -f ./charts/qualgo-apps/values.yaml -n $APP_NAMESPACE --create-namespace