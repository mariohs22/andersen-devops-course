resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = local.tags

  #   tags = {
  #     Name    = var.resource-name
  #     Project = var.resource-project
  #     Owner   = var.resource-owner
  #     Env     = var.resource-env
  #   }
}


resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = lookup(var.cidr_blocks, "zone${count.index}")

  #  cidr_block        = cidrsubnet(var.vpc_cidr, 2, count.index + length(slice(local.az_names, 0, 2)))


  availability_zone = lookup(var.zones, "zone${count.index}")
  #  map_public_ip_on_launch = true
  count = 2
}

# resource "aws_subnet" "subnet-00" {
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = var.subnet_00_cidr
#   availability_zone = "${var.region}b"

#   tags = {
#     Name        = "subnet-00-b"
#     Service     = var.service
#     Contact     = var.contact
#     Project     = var.project
#     Environment = var.env
#   }
# }

# resource "aws_subnet" "subnet-01" {
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = var.subnet_01_cidr
#   availability_zone = "${var.region}c"

#   tags = {
#     Name        = "subnet-01-c"
#     Service     = var.service
#     Contact     = var.contact
#     Project     = var.project
#     Environment = var.env
#   }
# }



resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = local.tags
}

resource "aws_default_route_table" "r" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = local.tags
}
