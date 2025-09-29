provider "aws" {
  region = var.region
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"

  create_vpc   = var.create_vpc
  vpc_id       = var.vpc_id
  cidr_block   = var.cidr_block
  azs          = var.azs
}

# IAM Module
module "iam" {
  source = "./modules/iam"

  create_iam_roles = var.create_iam_roles
  cluster_role_arn = var.cluster_role_arn
  node_role_arn    = var.node_role_arn
}

# EKS Module
module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  region          = var.region
  subnet_ids      = module.vpc.subnet_ids
  vpc_id          = module.vpc.vpc_id
  cluster_role_arn = module.iam.cluster_role_arn
  node_role_arn    = module.iam.node_role_arn
}
