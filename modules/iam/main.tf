# IAM module for using existing EKS roles only

variable "cluster_role_arn" {
  description = "IAM role ARN for EKS cluster"
  type        = string
}

variable "node_role_arn" {
  description = "IAM role ARN for EKS node group"
  type        = string
}

variable "create_iam_roles" {
  description = "Whether to create new IAM roles (not used when using existing roles)"
  type        = bool
  default     = false
}
/*variable "iam_user" {
  description = "IAM user to attach subnet tagging policy"
  type        = string
}*/


# -------------------------
# Outputs for EKS module
# -------------------------
output "cluster_role_arn" {
  value       = var.cluster_role_arn
  description = "ARN of the existing EKS cluster role"
}

output "node_role_arn" {
  value       = var.node_role_arn
  description = "ARN of the existing EKS node group role"
}
