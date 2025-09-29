# Only fetch subnets if none are provided
data "aws_subnets" "fetched" {
  count = length(var.subnet_ids) > 0 ? 0 : 1

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}
