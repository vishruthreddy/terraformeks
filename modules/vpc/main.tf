# -------------------------
# Create new VPC (only if vpc_id not provided)
# -------------------------
resource "aws_vpc" "this" {
  count = var.vpc_id == "" ? 1 : 0

  cidr_block = var.cidr_block
  tags = {
    Name = "${var.cluster_name}-vpc"
  }
}

# -------------------------
# Create new subnets (only if subnet_ids not provided)
# -------------------------
resource "aws_subnet" "this" {
  count = length(var.subnet_ids) == 0 ? length(var.azs) : 0

  vpc_id            = aws_vpc.this[0].id
  cidr_block        = cidrsubnet(var.cidr_block, 8, count.index)
  availability_zone = var.azs[count.index]
  tags = {
    Name = "${var.cluster_name}-subnet-${count.index}"
  }
}

