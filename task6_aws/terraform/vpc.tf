module "vpc" {
  source         = "terraform-aws-modules/vpc/aws"
  name           = "my-vpc"
  cidr           = var.vpc_cidr
  azs            = var.azs
  public_subnets = var.subnet_cidr
}
