# -------------------------
# Create cluster role
# -------------------------
resource "aws_iam_role" "eks_cluster_role" {
  count = var.create_iam_roles ? 1 : 0
  name  = "EKSClusterRole-TF4"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  count      = var.create_iam_roles ? 1 : 0
  role       = aws_iam_role.eks_cluster_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  count      = var.create_iam_roles ? 1 : 0
  role       = aws_iam_role.eks_cluster_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

# -------------------------
# Create node group role
# -------------------------
resource "aws_iam_role" "eks_node_role" {
  count = var.create_iam_roles ? 1 : 0
  name  = "EKSNodeRole-TF4"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node" {
  count      = var.create_iam_roles ? 1 : 0
  role       = aws_iam_role.eks_node_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni" {
  count      = var.create_iam_roles ? 1 : 0
  role       = aws_iam_role.eks_node_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_registry" {
  count      = var.create_iam_roles ? 1 : 0
  role       = aws_iam_role.eks_node_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}


variable "cluster_role_arn" {
  type = string
}

variable "node_role_arn" {
  type = string
}
variable "create_iam_roles" {
  type    = bool
  default = true
}

# -------------------------
# Outputs for EKS module
# -------------------------
output "cluster_role_arn" {
  value       = var.create_iam_roles ? aws_iam_role.eks_cluster_role[0].arn : null
  description = "ARN of the EKS cluster role"
}

output "node_role_arn" {
  value       = var.create_iam_roles ? aws_iam_role.eks_node_role[0].arn : null
  description = "ARN of the EKS node group role"
}