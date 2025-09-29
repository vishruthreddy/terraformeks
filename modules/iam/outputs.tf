output "cluster_role_arn" {
  value = var.create_iam_roles ? aws_iam_role.cluster_role[0].arn : var.cluster_role_arn
}

output "node_role_arn" {
  value = var.create_iam_roles ? aws_iam_role.node_role[0].arn : var.node_role_arn
}
