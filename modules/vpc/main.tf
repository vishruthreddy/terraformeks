variable "vpc_id" {
  description = "ID of the existing VPC to use"
  type        = string
}

variable "subnet_ids" {
  description = "List of existing subnet IDs (optional)"
  type        = list(string)
  default     = []
}

# Only fetch subnets if none are provided
data "aws_subnets" "fetched" {
  count = length(var.subnet_ids) > 0 ? 0 : 1

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}
output "vpc_id" {
  value = var.vpc_id
}

output "subnet_ids" {
  # Use provided subnet_ids if available; otherwise use fetched subnets
  value = length(var.subnet_ids) > 0 ? var.subnet_ids : data.aws_subnets.fetched[0].ids
}
