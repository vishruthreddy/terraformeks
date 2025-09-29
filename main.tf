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
# VPC Module - use existing
# -------------------------
module "vpc" {
  source = "./modules/vpc"
  vpc_id = var.vpc_id
}

# -------------------------
# IAM Module - imported roles
# -------------------------
module "iam" {
  source = "./modules/iam"
}

# -------------------------
# EKS Cluster Module
# -------------------------
module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  region          = var.region

  vpc_id          = module.vpc.vpc_id
  subnet_ids      = length(var.subnet_ids) > 0 ? var.subnet_ids : module.vpc.subnet_ids
  node_role_arn   = module.iam.node_role_arn
  cluster_role_arn = module.iam.cluster_role_arn
}
