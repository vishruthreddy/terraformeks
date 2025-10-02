variable "cluster_role_name" {
  description = "IAM role name for EKS cluster"
  type        = string
}

variable "node_role_name" {
  description = "IAM role name for EKS node group"
  type        = string
}

variable "create_iam_roles" {
  description = "Whether to create new IAM roles (not used when using existing roles)"
  type        = bool
  default     = false
}

# -------------------------
# Policy to allow viewing EKS nodes in console
# -------------------------
resource "aws_iam_policy" "view_eks_nodes" {
  name        = "ViewEKSNodesPolicy"
  description = "Allows viewing EKS node groups and EC2 instances for console visibility"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:ListNodegroups",
          "eks:DescribeNodegroup",
          "ec2:DescribeInstances",
          "ec2:DescribeTags",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach the policy to the existing node role (name is passed from root)
resource "aws_iam_role_policy_attachment" "attach_view_eks_nodes" {
  role       = var.node_role_name
  policy_arn = aws_iam_policy.view_eks_nodes.arn
}

# -------------------------
# Outputs for EKS module
# -------------------------
output "cluster_role_name" {
  value       = var.cluster_role_name
  description = "IAM role name of the existing EKS cluster role"
}

output "node_role_name" {
  value       = var.node_role_name
  description = "IAM role name of the existing EKS node group role"
}
