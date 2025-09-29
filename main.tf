provider "aws" {
  region = var.region
}

# -------------------------
# VPC Module - use existing
# -------------------------
module "vpc" {
  source = "./modules/vpc"
  vpc_id = var.vpc_id  # existing VPC ID, e.g., "vpc-5a863f32"
}

# -------------------------
# IAM Module - imported roles
# -------------------------
module "iam" {
  source = "./modules/iam"
  # The IAM roles are already imported:
  # eksClusterRole and eksNodeRole
}

# -------------------------
# EKS Module
# -------------------------
module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  region          = var.region

  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.subnet_ids

  cluster_role_arn = "arn:aws:iam::<account_id>:role/eksClusterRole"
  node_role_arn    = "arn:aws:iam::<account_id>:role/eksNodeRole"
}
