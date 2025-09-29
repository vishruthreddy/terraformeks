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

# -------------------------
# VPC variables
# -------------------------
variable "vpc_id" {
  description = "Existing VPC ID"
  type        = string
  default     = "vpc-5a863f32" # 👈 your VPC ID
}

variable "subnet_ids" {
  description = "List of existing subnet IDs"
  type        = list(string)
  default     = [
    "subnet-0b48100602cf769a7",
    "subnet-e6932a8e"
  ]
}

# -------------------------
# IAM role ARNs
# -------------------------
variable "cluster_role_arn" {
  description = "IAM role ARN for EKS cluster"
  type        = string
  default     = "arn:aws:iam::123456789012:role/eksClusterRole" # 👈 replace with your ARN
}

variable "node_role_arn" {
  description = "IAM role ARN for EKS nodes"
  type        = string
  default     = "arn:aws:iam::123456789012:role/eksNodeRole" # 👈 replace with your ARN
}
