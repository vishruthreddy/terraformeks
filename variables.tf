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
  description = "Existing VPC ID (leave empty to create new VPC)"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "List of existing subnet IDs (leave empty to create new subnets)"
  type        = list(string)
  default     = []
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
