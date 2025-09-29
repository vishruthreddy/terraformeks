variable "create_vpc" {
  type    = bool
  default = false   # set true to create new VPC
}

variable "vpc_id" {
  type    = string
  default = "vpc-5a863f32"  # your existing VPC ID
}

variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

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

# Output the VPC ID
output "vpc_id" {
  value = var.create_vpc && length(aws_vpc.this) > 0 ? aws_vpc.this[0].id : var.vpc_id
}

# Output the subnet IDs
output "subnet_ids" {
  value = var.create_vpc && length(aws_subnet.this) > 0 ? aws_subnet.this[*].id : data.aws_subnets.existing[0].ids
}
