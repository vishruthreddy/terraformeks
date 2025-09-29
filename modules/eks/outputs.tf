output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_oidc" {
  value = aws_eks_cluster.this.identity[0].oidc[0].issuer
}
