variable "create_vpc" {
  description = "Whether to create a new VPC or use an existing one"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "ID of an existing VPC to use (if create_vpc is false)"
  type        = string
  default     = "vpc-5a863f32"  # Replace with your existing VPC ID
}

variable "cidr_block" {
  description = "CIDR block for the VPC (if creating new)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones for subnets (if creating new VPC)"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
