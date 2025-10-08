# ----------------------------------------
# IAM variables for EKS
# ----------------------------------------
variable "cluster_role_arn" {
  description = "ARN of existing IAM role for EKS cluster"
  type        = string
  default     = ""
}

variable "node_role_arn" {
  description = "ARN of existing IAM role for EKS node group"
  type        = string
  default     = ""
}

variable "create_iam_roles" {
  description = "Whether to create new IAM roles if ARNs are not provided"
  type        = bool
  default     = true
}
