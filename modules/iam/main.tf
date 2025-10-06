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

# ----------------------------------------
# Policy to allow reading IAM policy versions
# ----------------------------------------
resource "aws_iam_policy" "eks_policy_permissions" {
  name        = "eks-policy-permissions"
  description = "Allow EKS/Terraform user to read IAM policies and versions"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:ListPolicyVersions"
        ]
        Resource = "*"
      }
    ]
  })
}

# ----------------------------------------
# Attach the policy to the existing cluster role
# ----------------------------------------
resource "aws_iam_role_policy_attachment" "attach_eks_policy_permissions" {
  count      = var.create_iam_roles == false ? 1 : 0
  role       = basename(var.cluster_role_arn)
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
