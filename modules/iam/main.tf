# ----------------------------------------
# Variables for existing EKS roles
# ----------------------------------------
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

resource "aws_iam_policy" "eks_policy_permissions" {
  name        = "eks-policy-permissions"
  description = "Policy for EKS Terraform operations"
  policy      = file("eks-policy-permissions.json")
}

resource "aws_iam_user_policy_attachment" "attach_policy" {
  user       = "MCCLOUD-374"
  policy_arn = aws_iam_policy.eks_policy_permissions.arn
}

# ----------------------------------------
# Outputs for EKS module
# ----------------------------------------
output "cluster_role_arn" {
  value       = var.cluster_role_arn
  description = "ARN of the existing EKS cluster role"
}

output "node_role_arn" {
  value       = var.node_role_arn
  description = "ARN of the existing EKS node group role"
}
