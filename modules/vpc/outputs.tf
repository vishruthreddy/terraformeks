output "vpc_id" {
  value = var.vpc_id
}

output "subnet_ids" {
  value = data.aws_subnets.existing.ids
}
