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
# VPC Module (existing VPC)
# -------------------------
module "vpc" {
  source = "./modules/vpc"

  vpc_id       = var.vpc_id
  subnet_ids   = var.subnet_ids
  cluster_name = var.cluster_name
}

# -------------------------
# IAM Module (use existing roles)
# -------------------------
module "iam" {
  source = "./modules/iam"

  create_iam_roles  = false  # ❌ Do NOT create roles
  cluster_role_arn  = var.cluster_role_arn
  node_role_arn     = var.node_role_arn
  
}

# -------------------------
# EKS Cluster Module
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

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "my-eks-cluster"
}

# -------------------------
# VPC variables
# -------------------------
variable "vpc_id" {
  description = "Existing VPC ID"
  type        = string
  default     = "vpc-5a863f32"
}



variable "subnet_ids" {
  description = "List of existing subnet IDs"
  type        = list(string)
  default     = [
    "subnet-e6932a8e",
    "subnet-3145b44b"
  ]
  
}

# -------------------------
# IAM role ARNs
# -------------------------
variable "cluster_role_arn" {
  description = "IAM role ARN for EKS cluster"
  type        = string
  default     = "arn:aws:iam::046692759124:role/eksClusterRole" 
}

variable "node_role_arn" {
  description = "IAM role ARN for EKS nodes"
  type        = string
  default     = "arn:aws:iam::046692759124:role/EKSnodegrouprole"
}

variable "permission_role_arn" {
  description = "IAM role ARN for EKS nodes"
  type        = string
  default     = "arn:aws:iam::046692759124:role/EKSVishrutPolicy"
}

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
  description = "Existing VPC ID"
  value       = module.vpc.vpc_id
}

output "subnet_ids" {
  description = "Subnets in the VPC"
  value       = module.vpc.subnet_ids
}

output "subnet_types" {
  description = "Type of subnets (public/private)"
  value       = module.vpc.subnet_types
}
