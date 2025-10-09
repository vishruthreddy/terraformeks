############################################################
# VPC Creation (only if vpc_id not provided)
############################################################
resource "aws_vpc" "this" {
  count = var.vpc_id == "" ? 1 : 0

  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.cluster_name}-vpc"
  }
}

############################################################
# Subnet Creation (only if subnet_ids not provided)
############################################################
resource "aws_subnet" "this" {
  count = length(var.subnet_ids) == 0 ? length(var.azs) : 0

  vpc_id                  = aws_vpc.this[0].id
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index)
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name                     = "${var.cluster_name}-subnet-${count.index}"
    "kubernetes.io/role/elb" = "1"
  }
}

############################################################
# Internet Gateway (only if VPC was created)
############################################################
resource "aws_internet_gateway" "this" {
  count = var.vpc_id == "" ? 1 : 0

  vpc_id = aws_vpc.this[0].id

  tags = {
    Name = "${var.cluster_name}-igw"
  }
}

############################################################
# Route Table (for public access)
############################################################
resource "aws_route_table" "this" {
  count = var.vpc_id == "" ? 1 : 0

  vpc_id = aws_vpc.this[0].id

  tags = {
    Name = "${var.cluster_name}-rt"
  }
}

############################################################
# Route to Internet Gateway
############################################################
resource "aws_route" "public_internet_access" {
  count = var.vpc_id == "" ? 1 : 0

  route_table_id         = aws_route_table.this[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id

  depends_on = [aws_internet_gateway.this]
}

############################################################
# Associate Subnets with Route Table
############################################################
resource "aws_route_table_association" "this" {
  count = length(var.subnet_ids) == 0 ? length(var.azs) : 0

  subnet_id      = aws_subnet.this[count.index].id
  route_table_id = aws_route_table.this[0].id
}



