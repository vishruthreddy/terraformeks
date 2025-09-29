module "vpc" {
  source = "./modules/vpc"
  vpc_id = "vpc-5a863f32"  # your existing VPC
}
