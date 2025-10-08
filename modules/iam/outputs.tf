# ----------------------------------------
# Outputs for IAM module
# ----------------------------------------
output "cluster_role_arn" {
  value       = var.cluster_role_arn != "" ? var.cluster_role_arn : aws_iam_role.cluster_role[0].arn
  description = "ARN of the EKS cluster IAM role"
}

output "node_role_arn" {
  value       = var.node_role_arn != "" ? var.node_role_arn : aws_iam_role.node_role[0].arn
  description = "ARN of the EKS node group IAM role"
}
