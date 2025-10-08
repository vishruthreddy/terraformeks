# -------------------------
# AWS & EKS variables
# -------------------------
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
# VPC variables (optional)
# -------------------------
variable "vpc_id" {
  description = "Existing VPC ID (leave empty to create a new VPC)"
  type        = string
  default     = "vpc-5a863f32"   # empty string indicates create new
}

variable "subnet_ids" {
  description = "List of existing subnet IDs (leave empty to create new subnets)"
  type        = list(string)
  default     = ["subnet-e6932a8e", "subnet-3145b44b"]   # empty list indicates create new
}

variable "cidr_block" {
  description = "CIDR block for new VPC (used if vpc_id is empty)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones for new subnets"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b"]
}

# -------------------------
# IAM role ARNs (optional)
# -------------------------
variable "cluster_role_arn" {
  description = "Existing IAM role ARN for EKS cluster (leave empty to create new)"
  type        = string
  default     = "arn:aws:iam::046692759124:role/eksClusterRole"  
}

variable "node_role_arn" {
  description = "Existing IAM role ARN for EKS nodes (leave empty to create new)"
  type        = string
  default     = "arn:aws:iam::046692759124:role/EKSnodegrouprole"
}

variable "create_iam_roles" {
  description = "Whether to create IAM roles if ARNs are not provided"
  type        = bool
  default     = true
}
