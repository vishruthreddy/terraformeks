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

# -------------------------
# Combined policy for viewing EKS nodes + IAM management
# -------------------------
resource "aws_iam_policy" "eks_and_iam_policy" {
  name        = "ViewEKSNodesAndManageIAMPolicy"
  description = "Allows viewing EKS node groups, EC2 instances, and IAM policy management for Terraform"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          # EKS & EC2 describe actions
          "eks:DescribeCluster",
          "eks:ListNodegroups",
          "eks:DescribeNodegroup",
          "ec2:DescribeInstances",
          "ec2:DescribeTags",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          
          # IAM actions for policy management
          "iam:CreatePolicy",
          "iam:AttachUserPolicy",
          "iam:GetPolicy",
          "iam:ListAttachedUserPolicies"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach the combined policy to the existing node role
resource "aws_iam_role_policy_attachment" "attach_eks_and_iam_policy" {
  role       = var.node_role_arn
  policy_arn = aws_iam_policy.eks_and_iam_policy.arn
}

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
