variable "cluster_name" { type = string }
variable "region" { type = string }
variable "subnet_ids" { type = list(string) }
variable "vpc_id" { type = string }
variable "cluster_role_arn" { type = string }
variable "node_role_arn" { type = string }
