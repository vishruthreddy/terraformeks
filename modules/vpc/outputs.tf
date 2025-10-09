# -------------------------
# Outputs
# -------------------------
output "vpc_id" {
  value = var.vpc_id != "" ? var.vpc_id : aws_vpc.this[0].id
}

output "subnet_ids" {
  value = length(var.subnet_ids) > 0 ? var.subnet_ids : [for s in aws_subnet.this : s.id]
}

output "subnet_types" {
  value = { for s in length(var.subnet_ids) > 0 ? var.subnet_ids : aws_subnet.this[*].id : s => "public" }
}

