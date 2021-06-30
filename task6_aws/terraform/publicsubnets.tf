locals {
  az_names       = data.aws_availability_zones.azs.names
  public_sub_ids = aws_subnet.public.*.id
}

resource "aws_subnet" "public" {
  count                   = length(slice(local.az_names, 0, 2))
  vpc_id                  = aws_vpc.task6_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 2, count.index)
  availability_zone       = local.az_names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "PublicSubnet-${count.index + 1}"
  }
}

# Internet Gateway Setup

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.task6_vpc.id

  tags = {
    Name = "task6-igw"
  }
}

# Route tables for public subnets

resource "aws_route_table" "publicrt" {
  vpc_id = aws_vpc.task6_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "task6-public-rt"
  }
}

# Subents association for public subnets

resource "aws_route_table_association" "pub_subnet_association" {
  count          = length(slice(local.az_names, 0, 2))
  subnet_id      = aws_subnet.public.*.id[count.index]
  route_table_id = aws_route_table.publicrt.id
}
