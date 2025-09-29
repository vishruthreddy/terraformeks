resource "aws_vpc" "this" {
  count = var.create_vpc ? 1 : 0
  cidr_block = var.cidr_block
}

resource "aws_subnet" "this" {
  count = var.create_vpc ? length(var.azs) : 0
  vpc_id = aws_vpc.this[0].id
  cidr_block = cidrsubnet(var.cidr_block, 8, count.index)
  availability_zone = var.azs[count.index]
}

output "vpc_id" {
  value = var.create_vpc ? aws_vpc.this[0].id : var.vpc_id
}

output "subnet_ids" {
  value = var.create_vpc ? aws_subnet.this[*].id : []
}
