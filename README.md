# HelmEnvVarSync

This project demonstrates how to pass environment variables to a Python application using Helm and Docker. The Python application simply displays the values of these environment variables.

## Table of Contents

- Project Structure
- Prerequisites
- Setup
- Deployment
- License

## Project Structure

```
HelmEnvVarSync/
├── app/
│   ├── app.py          # Python application
│   └── Dockerfile      # Docker configuration for Python app
├── helm/
│   ├── sampleapp/      # Helm chart for deployment
│       ├── charts/
│       ├── templates/
│       │   └── deployment.yaml
│       ├── values.yaml
│       └── Chart.yaml
└── README.md           # This file
```

## Prerequisites

- Docker installed and running.
- Kubernetes cluster set up and kubectl command-line tool installed.
- Helm installed.

## Setup
### Building and Pushing Docker Image:
Navigate to the app directory:

```
cd app
```

Build the Docker image:

```
docker build -t <YOUR_DOCKER_REPO>/helmenvvarsync:latest app/
```

Push the Docker image to your repository:

```
docker push <YOUR_DOCKER_REPO>/helmenvvarsync:latest
```

## Setting up Helm:
Navigate to the helm/sampleapp directory:

```
cd helm/sampleapp
```

Install dependencies (if any):

```
helm dependency update
```

## Deployment
To deploy the application to your Kubernetes cluster using the default environment variables:

```
helm install sampleapp ./helm/sampleapp
```

To deploy with custom environment variables:

```
helm install sampleapp ./helm/sampleapp --set env.VARIABLE1="Your Value 1" --set env.VARIABLE2="Your Value 2"
```

To dynamically update the environment variables in the deployed application:

```
helm upgrade sampleapp ./helm/sampleapp --set env.VARIABLE1="New Value 1" --set env.VARIABLE2="New Value 2"
```

You can verify the environment variables' values by checking the logs of the running pod:

1. Get the pod's name:

```
kubectl get pods
```

2. Check the logs:

```
kubectl logs <POD_NAME>
```

## License
This project is open-source and available under the MIT License. See LICENSE file for details.
