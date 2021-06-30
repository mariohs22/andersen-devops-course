terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.47"
    }
  }

  required_version = ">= 0.14.9"
}


# Create a VPC to launch our instances into
# resource "aws_vpc" "default" {
#   cidr_block = "10.0.0.0/16"
# }

# Create an internet gateway to give our subnet access to the outside world
# resource "aws_internet_gateway" "default" {
#   vpc_id = aws_vpc.default.id
# }

# Grant the VPC internet access on its main route table
# resource "aws_route" "internet_access" {
#   route_table_id         = aws_vpc.default.main_route_table_id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.default.id
# }

# Create a subnet to launch our instances into
# resource "aws_subnet" "default" {
#   vpc_id                  = aws_vpc.default.id
#   cidr_block              = "10.0.1.0/24"
#   map_public_ip_on_launch = true
# }

# A security group for the ELB so it is accessible via the web
# resource "aws_security_group" "elb" {
#   name        = "terraform_example_elb"
#   description = "Used in the terraform"
#   vpc_id      = aws_vpc.default.id

#   # HTTP access from anywhere
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   # outbound internet access
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# Our default security group to access the instances over SSH and HTTP
# resource "aws_security_group" "default" {
#   name        = "terraform_example"
#   description = "Used in the terraform"
#   vpc_id      = aws_vpc.default.id

#   # SSH access from anywhere
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   # HTTP access from the VPC
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["10.0.0.0/16"]
#   }

#   # outbound internet access
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_elb" "web" {
#   name = "terraform-example-elb"

#   subnets         = [aws_subnet.default.id]
#   security_groups = [aws_security_group.elb.id]
#   instances       = [aws_instance.EC2_instance_1.id]

#   listener {
#     instance_port     = 80
#     instance_protocol = "http"
#     lb_port           = 80
#     lb_protocol       = "http"
#   }
# }






data "aws_ami" "amazon_linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "EC2_instance_1" {
  ami           = data.aws_ami.amazon_linux2.id
  instance_type = var.instance_type

  key_name = aws_key_pair.this.key_name




  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = [aws_security_group.this.id]

  # We're going to launch into the same subnet as our ELB. In a production
  # environment it's more common to have a separate private subnet for
  # backend instances.
  subnet_id = data.terraform_remote_state.vpc.outputs.vpc.private_subnets[0]

  user_data = filebase64("${path.module}/templates/user_data.sh.tpl")
  tags = {
    Name = var.EC2_instance2_name
  }


}

# resource "aws_eip" "ip" {
#   instance = aws_instance.EC2_instance_1.id
# }
