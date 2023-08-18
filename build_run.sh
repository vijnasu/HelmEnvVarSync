#!/bin/bash

# Script to automate deployment steps for HelmEnvVarSync

# Variables
DOCKER_REPO=${1:-"<YOUR_DOCKER_REPO>"}
IMAGE_NAME="helmenvvarsync"
TAG="latest"
VAR1=${2:-"Default Value 1"}
VAR2=${3:-"Default Value 2"}

# Function to check the last command's result
check_result() {
  if [ $? -ne 0 ]; then
    echo "Error during $1, exiting..."
    exit 1
  fi
}

# Build Docker Image
cd app
docker build -t $DOCKER_REPO/$IMAGE_NAME:$TAG .
check_result "Docker build"

# Push Docker Image
docker push $DOCKER_REPO/$IMAGE_NAME:$TAG
check_result "Docker push"

# Navigate to Helm directory and install dependencies
cd ../helm/sampleapp
helm dependency update
check_result "Helm dependency update"

# Check if the Helm release already exists
helm list | grep sampleapp > /dev/null
if [ $? -eq 0 ]; then
  # Upgrade the existing release
  helm upgrade sampleapp . --set env.VARIABLE1="$VAR1" --set env.VARIABLE2="$VAR2"
  check_result "Helm upgrade"
else
  # Install new release
  helm install sampleapp . --set env.VARIABLE1="$VAR1" --set env.VARIABLE2="$VAR2"
  check_result "Helm install"
fi

echo "Deployment completed!"
