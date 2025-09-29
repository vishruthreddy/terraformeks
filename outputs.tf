output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_oidc" {
  description = "EKS cluster OIDC provider URL"
  value       = module.eks.cluster_oidc
}

output "vpc_id" {
  description = "Existing VPC ID"
  value       = module.vpc.vpc_id
}

output "subnet_ids" {
  description = "Subnets in the VPC"
  value       = module.vpc.subnet_ids
}
