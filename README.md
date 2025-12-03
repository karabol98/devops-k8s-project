# 🚀 Cloud-Native DevOps Project: End-to-End Microservices on AWS

This repository contains a full-stack DevOps project demonstrating a production-ready CI/CD pipeline, Infrastructure as Code (IaC), and Observability stack on AWS.

## 🏗 Architecture Overview
The project deploys a Python Flask application connected to a Redis database for state management. The entire infrastructure is provisioned programmatically using Terraform and deployed to an Amazon EKS (Kubernetes) cluster via GitHub Actions.

### Key Technologies
* **Cloud Provider:** AWS (EKS, ECR, VPC, IAM)
* **Infrastructure as Code:** Terraform
* **Containerization:** Docker
* **Orchestration:** Kubernetes (K8s)
* **CI/CD:** GitHub Actions
* **Database:** Redis (StatefulSet/Deployment)
* **Observability:** Prometheus & Grafana (Helm Charts)

---

## 🛠 Project Components

### 1. Application Layer (Microservices)
* **Frontend/API:** Python Flask app serving a JSON API with a visitor counter.
* **Database:** Redis instance for persisting hit counts.
* **Service Discovery:** Kubernetes Services (ClusterIP & LoadBalancer) handle internal networking.

### 2. Infrastructure (Terraform)
* Provisioned a custom **VPC** with Public/Private subnets across 2 Availability Zones.
* Created an **ECR Repository** for secure image storage.
* Deployed an **EKS Cluster (v1.30)** with Managed Node Groups (Spot Instances for cost optimization).

### 3. Automation (GitHub Actions)
* **Trigger:** Pushes to the `main` branch.
* **Pipeline Steps:**
    1.  Checkout code.
    2.  Authenticate with AWS.
    3.  Build Docker Image & Push to ECR.
    4.  Update Kubernetes Manifests dynamically.
    5.  Deploy to EKS (Zero-Downtime Deployment).

### 4. Observability (Helm)
* Deployed **kube-prometheus-stack** using Helm.
* Configured **Grafana** dashboards to monitor Cluster CPU, Memory, and Network traffic.

---

## 📸 Proof of Implementation

### ✅ "Infrastructure
*(<img width="1399" height="330" alt="Στιγμιότυπο οθόνης 2025-12-03 130527" src="https://github.com/user-attachments/assets/6994f6ea-35e5-495a-8982-83526d9ed08a" />)*

### ✅ CI/CD Pipeline Success
*(Drag & Drop το screenshot του GitHub Actions εδώ)*

### ✅ Application Live (Load Balancer)
*(<img width="902" height="182" alt="Στιγμιότυπο οθόνης 2025-12-03 130210" src="https://github.com/user-attachments/assets/1f53a1e7-0477-4ecb-8b38-3110055065ae" />)*

### ✅ Observability (Grafana Dashboard)
*(<img width="1361" height="815" alt="Στιγμιότυπο οθόνης 2025-12-03 141738" src="https://github.com/user-attachments/assets/87c488c0-d4ec-432d-88b0-4a32b2de131f" />)*

*(<img width="1369" height="845" alt="Στιγμιότυπο οθόνης 2025-12-03 141719" src="https://github.com/user-attachments/assets/22b99c4f-02ca-4e23-86e0-06d898b6d483" />)*

### ✅ Deployment Verification (Terminal)
*(<img width="1369" height="672" alt="Στιγμιότυπο οθόνης 2025-12-03 141646" src="https://github.com/user-attachments/assets/38360f4b-a3cf-4250-b2bd-67d4981698e8" />)*

---


## 🚀 How to Reproduce

### Prerequisites
* AWS CLI & Terraform installed.
* Docker & Kubectl installed.
* Helm installed.

### Step 1: Provision Infrastructure
```bash
cd terraform
terraform init
terraform apply --auto-approve

### Step 2: Deploy Monitoring Stack
```bash
helm repo add prometheus-community [https://prometheus-community.github.io/helm-charts](https://prometheus-community.github.io/helm-charts)
helm install monitoring prometheus-community/kube-prometheus-stack

### Step 3: Access the App
```bash
The GitHub Actions pipeline will automatically deploy the app. Retrieve the URL:
kubectl get svc my-devops-service

## 🧹Cost Management (Teardown)

To avoid AWS charges, the infrastructure is destroyed after use:
cd terraform
terraform destroy --auto-approve
