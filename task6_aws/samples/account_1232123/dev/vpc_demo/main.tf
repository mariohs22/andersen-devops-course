locals {
  vpc_name = format("%s-%s", var.env, var.project)
}

module "vpc" {
  source         = "../../../modules/vpc" #"git@github.com:organization/shared-terraform-modules.git//vpc"
  cidr           = var.cidr
  public_subnets = var.public_subnets
  private_subnets = {
    private = {
      subnets = var.private_subnets
      tags    = {}
    }
  }
  single_nat_gateway   = var.single_nat_gateway
  name                 = local.vpc_name
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags                 = local.tags
}
