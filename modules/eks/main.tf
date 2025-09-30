# -------------------------
# Variables
# -------------------------
variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for EKS cluster"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID (optional)"
  type        = string
  default     = ""
}

variable "cluster_role_arn" {
  description = "ARN of existing IAM role for EKS cluster"
  type        = string
}

variable "node_role_arn" {
  description = "ARN of existing IAM role for EKS node group"
  type        = string
}

# -------------------------
# EKS Cluster
# -------------------------
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }
}

# -------------------------
# EKS Node Group
# -------------------------
resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
}

# -------------------------
# Outputs
# -------------------------
output "cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.this.name
}

output "cluster_oidc" {
  description = "EKS cluster OIDC issuer URL"
  value       = lookup(aws_eks_cluster.this.identity[0].oidc[0], "issuer", "")
}
