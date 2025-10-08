# Existing VPC & subnets (optional)
variable "vpc_id" {
  description = "ID of the existing VPC to use (leave empty to create a new VPC)"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "List of existing subnet IDs (leave empty to create new subnets)"
  type        = list(string)
  default     = []
}

variable "cluster_name" {
  description = "Name of the EKS cluster (used for tagging)"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for new VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones for new subnets"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b"]
}
