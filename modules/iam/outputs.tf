# -------------------------
# Outputs for EKS module
# -------------------------
output "cluster_role_arn" {
  value       = var.create_iam_roles ? aws_iam_role.eks_cluster_role[0].arn : null
  description = "ARN of the EKS cluster role"
}

output "node_role_arn" {
  value       = var.create_iam_roles ? aws_iam_role.eks_node_role[0].arn : null
  description = "ARN of the EKS node group role"
}