# Create private subnets
resource "aws_subnet" "private" {
  count             = length(slice(local.az_names, 0, 2))
  vpc_id            = aws_vpc.task6_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 2, count.index + length(slice(local.az_names, 0, 2)))
  availability_zone = local.az_names[count.index]
  tags = {
    Name = "PrivateSubnet-${count.index + 1}"
  }
}

# Elastic IP for NAT Gateway

resource "aws_eip" "nat" {
  vpc = true
}


# Create NAT Gateway for private subnets
resource "aws_nat_gateway" "ngw" {
  #  count         = length(slice(local.az_names, 0, 2))
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.*.id[0]

  tags = {
    Name = "NatGateway"
  }
}

output "nat_gateway_ip" {
  value = aws_eip.nat.public_ip
}

# Route tables for private subnets

resource "aws_route_table" "privatert" {
  vpc_id = aws_vpc.task6_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name = "task6-private-rt"
  }
}

# Subents association for private subnets

resource "aws_route_table_association" "private_subnet_association" {
  count          = length(slice(local.az_names, 0, 2))
  subnet_id      = aws_subnet.private.*.id[count.index]
  route_table_id = aws_route_table.privatert.id
}
