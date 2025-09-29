variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "my-eks-cluster"
}

# VPC variables
variable "create_vpc" {
  description = "Whether to create a new VPC"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "Existing VPC ID (if create_vpc = false)"
  type        = string
  default     = ""
}

variable "cidr_block" {
  description = "CIDR block for new VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# IAM variables
variable "create_iam_roles" {
  description = "Whether to create IAM roles"
  type        = bool
  default     = true
}

variable "cluster_role_arn" {
  description = "Existing IAM role ARN for EKS cluster"
  type        = string
  default     = ""
}

variable "node_role_arn" {
  description = "Existing IAM role ARN for EKS nodes"
  type        = string
  default     = ""
}
