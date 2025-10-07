# Define the custom IAM policy for viewing EKS clusters and nodes
resource "aws_iam_policy" "eks_viewer_policy" {
  name        = "EKSViewerPolicy"
  description = "Custom policy to allow viewing EKS clusters and nodes"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:DescribeNodegroup",
          "eks:ListNodegroups",
          "eks:ListUpdates",
          "eks:AccessKubernetesApi"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach the policy to your IAM user
resource "aws_iam_user_policy_attachment" "eks_viewer_attachment" {
  user       = "MCCLOUD-374"
  policy_arn = aws_iam_policy.eks_viewer_policy.arn
}
