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

  vpc_id       = var.vpc_id
  subnet_ids   = var.subnet_ids
  cluster_name = var.cluster_name
}

# -------------------------
# IAM Module (existing roles)
# -------------------------
module "iam" {
  source = "./modules/iam"

  create_iam_roles  = false
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
