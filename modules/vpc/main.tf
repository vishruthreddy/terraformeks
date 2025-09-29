# Create VPC if requested
resource "aws_vpc" "this" {
  count      = var.create_vpc ? 1 : 0
  cidr_block = var.cidr_block
  tags = {
    Name = "terraform-eks-vpc"
  }
}

# Create subnets if VPC is created
resource "aws_subnet" "this" {
  count             = var.create_vpc ? length(var.azs) : 0
  vpc_id            = aws_vpc.this[0].id
  cidr_block        = cidrsubnet(var.cidr_block, 8, count.index)
  availability_zone = var.azs[count.index]
  tags = {
    Name = "terraform-eks-subnet-${count.index}"
  }
}

# Fetch existing subnets if using existing VPC
data "aws_subnets" "existing" {
  count = var.create_vpc ? 0 : 1
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}
