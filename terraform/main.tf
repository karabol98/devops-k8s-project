terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

# --- 1. ECR Repository (Το κρατάμε) ---
resource "aws_ecr_repository" "app_repo" {
  name                 = "my-devops-app-repo"
  image_tag_mutability = "MUTABLE"
  force_delete         = true  # Για να σβήνει εύκολα όταν κάνουμε destroy
}

# --- 2. VPC (Το Δίκτυο) ---
# Χρειαζόμαστε δικό μας δίκτυο για να μπει το Kubernetes
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "devops-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-central-1a", "eu-central-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true # Για οικονομία (ένα NAT αντί για δύο)
  enable_dns_hostnames = true
}

# --- 3. EKS Cluster (Το Kubernetes) ---
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.3"

  cluster_name    = "my-devops-cluster"
  cluster_version = "1.30"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access = true # Για να μπορούμε να συνδεθούμε από το laptop μας

  # Εδώ ορίζουμε τους servers (Nodes)
  eks_managed_node_groups = {
    green = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.small"] # Μικρό και φθηνό instance
      capacity_type  = "SPOT"       # Spot instances (πολύ πιο φθηνά από τα κανονικά)
    }
  }
}

# --- Outputs ---
output "repository_url" {
  value = aws_ecr_repository.app_repo.repository_url
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_name" {
  value = module.eks.cluster_name
}