terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.14"
    }
  }
}

provider "aws" {
  region = var.region
}

# -------------------------
# VPC Module
# -------------------------
module "vpc" {
  source = "./modules/vpc"

  # If existing VPC/subnets provided, use them; otherwise create new
  
  vpc_id       = var.vpc_id
  subnet_ids   = var.subnet_ids
  cidr_block   = var.cidr_block
  azs          = var.azs
  cluster_name = var.cluster_name
}

# -------------------------
# IAM Module
# -------------------------
module "iam" {
  source = "./modules/iam"

  # Use existing IAM roles if provided; otherwise create new
  create_iam_roles  = var.cluster_role_arn == "" || var.node_role_arn == ""
  cluster_role_arn  = var.cluster_role_arn
  node_role_arn     = var.node_role_arn
}

# -------------------------
# EKS Module
# -------------------------
module "eks" {
  source = "./modules/eks"

  cluster_name     = var.cluster_name
  region           = var.region

  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.vpc.subnet_ids
  cluster_role_arn = module.iam.cluster_role_arn
  node_role_arn    = module.iam.node_role_arn
}

# -------------------------
# Outputs
# -------------------------
output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_oidc" {
  description = "EKS cluster OIDC provider URL"
  value       = module.eks.cluster_oidc
}

output "vpc_id" {
  description = "VPC ID used by EKS"
  value       = module.vpc.vpc_id
}

output "subnet_ids" {
  description = "Subnets used by EKS"
  value       = module.vpc.subnet_ids
}

output "subnet_types" {
  description = "Type of subnets (public/private)"
  value       = module.vpc.subnet_types
}
