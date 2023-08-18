# HelmEnvVarSync

This project demonstrates how to pass environment variables to a Python application using Helm and Docker. The Python application simply displays the values of these environment variables.

## Table of Contents

- Project Structure
- Prerequisites
- Development
- Automated Setup & Deployment using `build_run.sh`
- Manual Setup & Deployment
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
├── build_run.sh        # Automated build and deployment script
└── README.md           # This file
```

## Prerequisites

- Docker installed and running.
- Kubernetes cluster set up and kubectl command-line tool installed.
- Helm installed.

## Development

### Python Application

1. First, we'll create a simple Python application that reads the environment variables and displays them.

`app.py`:
```python
import os
import time

def main():

    print("Starting application...")

    variable1 = os.environ.get("VARIABLE1", "Not Set")
    variable2 = os.environ.get("VARIABLE2", "Not Set")

    while True:
        print("VARIABLE1:", os.environ.get("VARIABLE1", "Not Set"))
        print("VARIABLE2:", os.environ.get("VARIABLE2", "Not Set"))
        time.sleep(10)  # Pause for 10 seconds before printing again

    print("Ending application...")

if __name__ == "__main__":
    main()
```

2. Dockerfile for Python Application

`Dockerfile`:
```
FROM python:3.9-slim

WORKDIR /app

COPY app.py .

CMD ["python", "-u", "/app/app.py"]
```

3. Helm Chart

You can create a Helm chart using the following command:

```
cd helm
helm create sampleapp
cd ..
```

Inside this sampleapp directory, adjust the following files:

`helm/sampleapp/values.yaml`:
```
image:
  repository: myrepo/myimage
  tag: latest

env:
  VARIABLE1: "Initial Value 1"
  VARIABLE2: "Initial Value 2"
sampleapp/templates/deployment.yaml:
```
`yaml`
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}
spec:
  replicas: 1
  template:
    spec:
      containers:
      - name: sample-container
        image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
        env:
        - name: VARIABLE1
          value: "{{ .Values.env.VARIABLE1 }}"
        - name: VARIABLE2
          value: "{{ .Values.env.VARIABLE2 }}"
```

## Automated Deployment using build_run.sh
To simplify the deployment process, you can use the `build_run.sh` script. This script will build the Docker image, push it to the specified Docker repository, and deploy or upgrade the Helm release with optional environment variables.

Provide execute permissions to the script:

```
chmod +x build_run.sh
```

Run the script:

```
./build_run.sh [YOUR_DOCKER_REPO] [OPTIONAL_VAR1] [OPTIONAL_VAR2]
```

Replace `[YOUR_DOCKER_REPO]` with your Docker repository. You can also provide optional values for `VARIABLE1` and `VARIABLE2` by replacing `[OPTIONAL_VAR1]` and `[OPTIONAL_VAR2]`.

## Manual Setup & Deployment
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

## Manual Deployment
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
