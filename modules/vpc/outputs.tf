output "vpc_id" {
  value = var.vpc_id
}

output "subnet_ids" {
  # Use provided subnet_ids if available; otherwise use fetched subnets
  value = length(var.subnet_ids) > 0 ? var.subnet_ids : data.aws_subnets.fetched[0].ids
}
