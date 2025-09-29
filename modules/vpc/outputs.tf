# Output the VPC ID (created or existing)
output "vpc_id" {
  value = var.create_vpc && length(aws_vpc.this) > 0 ? aws_vpc.this[0].id : var.vpc_id
}

# Output the subnet IDs
output "subnet_ids" {
  value = var.create_vpc && length(aws_subnet.this) > 0 ? aws_subnet.this[*].id : data.aws_subnets.existing[0].ids
}
