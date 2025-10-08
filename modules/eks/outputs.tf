# -------------------------
# EKS module outputs
# -------------------------
output "cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.this.name
}

output "cluster_oidc" {
  description = "EKS cluster OIDC issuer URL"
  value       = lookup(aws_eks_cluster.this.identity[0].oidc[0], "issuer", "")
}
