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
resource "aws_iam_policy" "eks_nodegroup_asg_view" {
  name        = "eks-nodegroup-asg-view"
  description = "Allow EKS node group IAM role to view Auto Scaling Group for console"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeScalingActivities",
          "autoscaling:DescribeScalingInstances",
          "autoscaling:DescribeLaunchConfigurations"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_asg_policy_to_node_role" {
  role       = var.node_role_arn
  policy_arn = aws_iam_policy.eks_nodegroup_asg_view.arn
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
