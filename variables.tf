# AWS region
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

# EKS cluster name
variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "my-eks-cluster"
}

# Existing VPC ID
variable "vpc_id" {
  description = "Existing VPC ID to use"
  type        = string
  default     = "vpc-5a863f32"
}
