# Output the VPC ID
output "vpc_id" {
  value = var.vpc_id
}

# Output the subnet IDs in the VPC
output "subnet_ids" {
  value = data.aws_subnets.existing.ids
}
