# -------------------------
# EKS module variables
# -------------------------
variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for EKS cluster"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "List of subnet IDs for EKS cluster"
  type        = list(string)
}

variable "cluster_role_arn" {
  description = "ARN of IAM role for EKS cluster"
  type        = string
}

variable "node_role_arn" {
  description = "ARN of IAM role for EKS node group"
  type        = string
}
