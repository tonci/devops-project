# DevOps final project

The project so far consist of a simple java (Spring Boot application) that serves as an API server.

The code for the API server is located in the `api` folder. It contains a `Dockerfile` that builds the image for the API server based on `openjdk:21-ea-34-slim` image.

## How to run the project
1. Manually start ```Initialize Terraform Lock and State``` workflow
2. Manually start ```Terraform AWS EKS Push Apply``` workflow
3. Install ArgoCD on the Kubernetes cluster
```shell
# From the infra/terraform/k8s directory run
aws eks --region $(terraform output -raw region) update-kubeconfig \
    --name $(terraform output -raw cluster_name)
# this will configure kubectl to use the EKS cluster

# Create argocd namespace
kubectl create namespace argocd
# Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
# Expose ArgoCD server as LoadBalancer service
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
# Get ArgoCD initial server password
argocd admin initial-password -n argocd
# Get the ArgoCD server LoadBalancer service external address, login and change the password
kubectl get svc -n argocd
# Delete the ArgoCD initial admin secret
kubectl delete secret argocd-initial-admin-secret -n argocd
```
4. Login to ArgoCD and add new application pointing to this repository at ```k8s``` directory
5. Run ```kubectl get svc``` to get the app LoadBalancer service external address.

## Dependabot
- Enabled security updates
- Enabled and configured for version updates on:
  - Docker
  - Maven
  - GitHub Actions
- Enabled alerts for secret detection + commit prevention

## Terraform
- Provisioned S3 bucket for Terraform state
- Provisioned DynamoDB table for Terraform state locking
- Provisioned EKS cluster with Terraform using S3 bucket and DynamoDB table for state management

## Kubernetes cluster
- Deployment - consists of 3 replicas of the API server
- Service - LoadBalancer service exposes the API server deployment on port 8080
- Kustomize - used to manage the Kubernetes manifests

## Github Actions
### Build and deploy when changes to the java application are pushed
```Build API and push to Docker Hub```
- Build and push the API server image to Docker Hub
  - Unit tests
  - Build Java application
  - Export environment variable for java version
  - Upload jar as artifact
- Build and push the API server image to Docker Hub [tonci123/devops-java-api](https://hub.docker.com/r/tonci123/devops-java-api)
  - Build Docker image
  - Use java version to tag the docker image
  - Push Docker image to Docker Hub
- Update Kubernetes deployment
  - User java version to update the image tag in the Kubernetes Deployment
- ArgoCD automatically detects changes on the k8s directory and updates the Kubernetes cluster

### Initial terraform state and lock provisioning
```Initialize Terraform Lock and State```
- Provision S3 bucket for Terraform state and DynamoDB table for state locking

### Provision EKS cluster check
```Terraform AWS EKS Checks```
- Run terraform ```fmt```, ```validate``` and ```plan``` to validate the Terraform configuration on changes.
- On any push to any branch when changes to the infra/terraform/k8s directory are pushed.

### Provision EKS cluster apply
```Terraform AWS EKS Push Apply```
- Run terraform ```fmt```, ```validate```, ```plan``` and ```apply``` to validate the Terraform configuration on changes.
- On push to ```main``` branch when changes to the infra/terraform/k8s directory are pushed.