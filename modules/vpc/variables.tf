variable "create_vpc" { type = bool }
variable "vpc_id" { type = string }
variable "cidr_block" { type = string }
variable "azs" { type = list(string) }
