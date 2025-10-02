# -------------------------
# Variables
# -------------------------
variable "vpc_id" {
  description = "ID of the existing VPC to use"
  type        = string
}

variable "subnet_ids" {
  description = "List of existing subnet IDs"
  type        = list(string)
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

# -------------------------
# Tag existing subnets for EKS
# -------------------------
resource "aws_ec2_tag" "eks_subnet_tags" {
  for_each    = toset(var.subnet_ids)
  resource_id = each.key
  key         = "kubernetes.io/cluster/${var.cluster_name}"
  value       = "shared"
}

resource "aws_ec2_tag" "eks_role_tag" {
  for_each    = toset(var.subnet_ids)
  resource_id = each.key
  key         = "kubernetes.io/role/elb"
  value       = "1"
}

# -------------------------
# Outputs
# -------------------------
output "vpc_id" {
  value = var.vpc_id
}

output "subnet_ids" {
  value = var.subnet_ids
}

output "subnet_types" {
  value = { for s in var.subnet_ids : s => "public" }
}
