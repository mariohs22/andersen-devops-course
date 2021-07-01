# locals {
#   env_tag = {
#     Environment = terraform.workspace
#   }
#   tags = merge(var.ec2_tags, local.env_tag)
# }

# data "aws_ami" "amazon_linux2" {
#   most_recent = true
#   owners      = ["amazon"]

#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm*"]
#   }
# }

data "aws_ami" "ubuntu-linux-1904" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-disco-19.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "instance" {
  ami           = data.aws_ami.ubuntu-linux-1904.id
  instance_type = var.instance_type
  #  key_name                    = var.aws-keypair-name
  subnet_id                   = aws_subnet.subnet.*.id[count.index]
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_http.id]
  user_data                   = file("user_data.sh")
  count                       = 2

  tags = {
    Name        = "web-0${count.index}"
    Project     = var.project
    Environment = var.env
  }
}






# resource "aws_instance" "web" {
#   count = 2
#   #  ami                    = var.ec2_amis[var.region]
#   ami                    = data.aws_ami.amazon_linux2.id
#   instance_type          = var.instance_type
#   subnet_id              = aws_subnet.private.*.id[count.index]
#   tags                   = var.ec2_tags
#   user_data              = file("scripts/nginx.sh")
#   iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
#   vpc_security_group_ids = [aws_security_group.ec2_sg.id]
# }
