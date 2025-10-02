# -------------------------
# IAM Policy for EKS & EC2 tagging
# -------------------------
resource "aws_iam_policy" "eks_subnet_tag_policy" {
  name        = "EKSSubnetTagPolicy"
  description = "Allows tagging EC2 subnets for EKS cluster"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "ec2:DescribeTags",
          "ec2:CreateTags",
          "ec2:DeleteTags"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "eks:UpdateClusterConfig"
        ]
        Resource = "*"
      }
    ]
  })
}

# -------------------------
# Attach the policy to the user
# -------------------------
resource "aws_iam_user_policy_attachment" "attach_eks_subnet_tag_policy" {
  user       = "MCCLOUD-374"
  policy_arn = aws_iam_policy.eks_subnet_tag_policy.arn
}
