terraform {
  required_version = ">=1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.25"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~>2.12"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

############################
# VPC
############################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~>5.0"

  name = "sre-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24","10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24","10.0.4.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
}

############################
# EKS CLUSTER
############################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~>20.0"

  cluster_name    = "sre-eks-cluster"
  cluster_version = "1.29"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    sre_nodes = {
      instance_types = ["t3.medium"]
      min_size       = 1
      max_size       = 3
      desired_size   = 2
    }
  }
}

############################
# EKS DATA SOURCES
############################

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

############################
# KUBERNETES PROVIDER
############################

provider "kubernetes" {

  host = data.aws_eks_cluster.cluster.endpoint

  cluster_ca_certificate = base64decode(
    data.aws_eks_cluster.cluster.certificate_authority[0].data
  )

  token = data.aws_eks_cluster_auth.cluster.token
}

############################
# HELM PROVIDER
############################

provider "helm" {
  kubernetes {

    host = data.aws_eks_cluster.cluster.endpoint

    cluster_ca_certificate = base64decode(
      data.aws_eks_cluster.cluster.certificate_authority[0].data
    )

    token = data.aws_eks_cluster_auth.cluster.token
  }
}

############################
# ARGOCD
############################

resource "helm_release" "argocd" {

  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

  namespace = "argocd"

  create_namespace = true
}

############################
# PROMETHEUS + GRAFANA
############################

resource "helm_release" "monitoring" {

  name = "monitoring"

  repository = "https://prometheus-community.github.io/helm-charts"

  chart = "kube-prometheus-stack"

  namespace = "monitoring"

  create_namespace = true
}

############################
# OPENTELEMETRY
############################

resource "helm_release" "otel" {

  name = "opentelemetry"

  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"

  chart = "opentelemetry-collector"

  namespace = "observability"

  create_namespace = true
}

############################
# OUTPUTS
############################

output "cluster_name" {
  value = module.eks.cluster_name
}

output "argocd_access" {
  value = "kubectl port-forward svc/argocd-server 8080:443 -n argocd"
}

output "grafana_access" {
  value = "kubectl port-forward svc/monitoring-grafana 3000:80 -n monitoring"
}