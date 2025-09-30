variable "cluster_role_arn" {
  type = string
}

variable "node_role_arn" {
  type = string
}
variable "create_iam_roles" {
  type    = bool
  default = true
}