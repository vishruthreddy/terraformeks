# -------------------------
# Variables
# -------------------------
variable "vpc_id" {
  description = "ID of the existing VPC to use"
  type        = string
}

variable "subnet_ids" {
  description = "List of existing subnet IDs"
  type        = list(string)
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

# -------------------------
# Outputs
# -------------------------
output "vpc_id" {
  value = var.vpc_id
}

output "subnet_ids" {
  value = var.subnet_ids
}

output "subnet_types" {
  value = { for s in var.subnet_ids : s => "public" }
}
