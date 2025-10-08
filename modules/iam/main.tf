# ----------------------------------------
# Data: Assume Role Policies
# ----------------------------------------
data "aws_iam_policy_document" "cluster_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "node_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# ----------------------------------------
# Create EKS Cluster Role (if needed)
# ----------------------------------------
resource "aws_iam_role" "cluster_role" {
  count              = var.create_iam_roles && var.cluster_role_arn == "" ? 1 : 0
  name               = "eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.cluster_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "cluster_role_attach" {
  count      = var.create_iam_roles && var.cluster_role_arn == "" ? 1 : 0
  role       = aws_iam_role.cluster_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# ----------------------------------------
# Create EKS Node Role (if needed)
# ----------------------------------------
resource "aws_iam_role" "node_role" {
  count              = var.create_iam_roles && var.node_role_arn == "" ? 1 : 0
  name               = "eks-node-role"
  assume_role_policy = data.aws_iam_policy_document.node_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "node_role_attach" {
  count      = var.create_iam_roles && var.node_role_arn == "" ? 1 : 0
  role       = aws_iam_role.node_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "node_cni_attach" {
  count      = var.create_iam_roles && var.node_role_arn == "" ? 1 : 0
  role       = aws_iam_role.node_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSCNIPolicy"
}

resource "aws_iam_role_policy_attachment" "node_registry_attach" {
  count      = var.create_iam_roles && var.node_role_arn == "" ? 1 : 0
  role       = aws_iam_role.node_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

