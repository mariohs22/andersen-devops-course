resource "aws_vpc" "task6_vpc" {
  #provider             = aws.region
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = "task6_vpc",
    Environment = terraform.workspace
  }
}
