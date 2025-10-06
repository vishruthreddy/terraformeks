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
# Policy to allow Terraform user to read IAM policies
# ----------------------------------------
resource "aws_iam_policy" "eks_user_policy_permissions" {
  name        = "EKSVishrutPolicyPermissions"
  description = "Allow Terraform user MCCLOUD-374 to read IAM policies and versions"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:ListPolicyVersions",
          "iam:ListAttachedUserPolicies"
        ]
        Resource = "*"
      }
    ]
  })
}

# ----------------------------------------
# Attach this policy to the Terraform user
# ----------------------------------------
resource "aws_iam_user_policy_attachment" "attach_eks_user_policy" {
  user       = "MCCLOUD-374"
  policy_arn = aws_iam_policy.eks_user_policy_permissions.arn
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

output "permission_role_arn" {
  value       = var.permission_role_arn
  description = "ARN of the existing EKS permission role"
}