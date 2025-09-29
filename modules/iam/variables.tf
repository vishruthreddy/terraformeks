variable "create_iam_roles" {
  description = "Whether to create IAM roles"
  type        = bool
  default     = false
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
