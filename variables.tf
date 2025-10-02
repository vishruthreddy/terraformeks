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
# VPC variables
# -------------------------
variable "vpc_id" {
  description = "Existing VPC ID"
  type        = string
  default     = "vpc-5a863f32"
}

variable "subnet_ids" {
  description = "List of existing subnet IDs"
  type        = list(string)
  default     = [
    "subnet-e6932a8e",
    "subnet-3145b44b"
  ]
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

