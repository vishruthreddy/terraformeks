data "aws_iam_policy_document" "eks_cluster_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "cluster_role" {
  count = var.create_iam_roles ? 1 : 0
  name  = "eksClusterRole"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume.json
}

data "aws_iam_policy_document" "eks_node_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "node_role" {
  count = var.create_iam_roles ? 1 : 0
  name  = "eksNodeRole"
  assume_role_policy = data.aws_iam_policy_document.eks_node_assume.json
}
