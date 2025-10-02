# -------------------------
# Variables
# -------------------------
variable "vpc_id" {
  description = "ID of the existing VPC to use"
  type        = string
}

variable "subnet_ids" {
  description = "List of existing subnet IDs (optional)"
  type        = list(string)
  default     = []
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

# -------------------------
# Fetch subnets if none provided
# -------------------------
data "aws_subnets" "fetched" {
  count = length(var.subnet_ids) > 0 ? 0 : 1

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

# Determine which subnet IDs to use
locals {
  subnet_ids_used = length(var.subnet_ids) > 0 ? var.subnet_ids : data.aws_subnets.fetched[0].ids
}

# -------------------------
# Fetch route tables for subnets
# -------------------------
data "aws_route_table" "subnet_routes" {
  for_each = toset(local.subnet_ids_used)

  filter {
    name   = "association.subnet-id"
    values = [each.key]
  }
}

# -------------------------
# Determine if subnet is public or private
# -------------------------
locals {
  subnet_types = {
    for subnet_id, rt in data.aws_route_table.subnet_routes :
    subnet_id => length([for r in rt.routes : r.gateway_id if r.gateway_id != null && startswith(r.gateway_id, "igw-")]) > 0 ? "public" : "private"
  }
}

# -------------------------
# Tag existing subnets for EKS
# -------------------------
resource "aws_ec2_tag" "eks_subnet_tags" {
  for_each = toset(local.subnet_ids_used)

  resource_id = each.key
  key         = "kubernetes.io/cluster/${var.cluster_name}"
  value       = "shared"
}

resource "aws_ec2_tag" "eks_role_tag" {
  for_each = toset(local.subnet_ids_used)

  resource_id = each.key
  key         = local.subnet_types[each.key] == "public" ? "kubernetes.io/role/elb" : "kubernetes.io/role/internal-elb"
  value       = "1"
}


# -------------------------
# Outputs
# -------------------------
output "vpc_id" {
  value = var.vpc_id
}

output "subnet_ids" {
  value = local.subnet_ids_used
}

output "subnet_types" {
  value = local.subnet_types
}
