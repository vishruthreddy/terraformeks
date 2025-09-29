variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "my-eks-cluster"
}

variable "vpc_id" {
  description = "Existing VPC ID"
  type        = string
  default     = "vpc-5a863f32"
}
variable "subnet_ids" {
  description = "Subnets to use for the EKS cluster"
  type        = list(string)
  default     = []
}
