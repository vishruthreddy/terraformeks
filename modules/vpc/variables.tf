variable "vpc_id" {
  description = "ID of the existing VPC to use"
  type        = string
}

variable "subnet_ids" {
  description = "List of existing subnet IDs (optional)"
  type        = list(string)
  default     = []
}
