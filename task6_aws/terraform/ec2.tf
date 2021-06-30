locals {
  env_tag = {
    Environment = terraform.workspace
  }
  tags = merge(var.ec2_tags, local.env_tag)
}

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

resource "aws_instance" "web" {
  count = 2
  #  ami                    = var.ec2_amis[var.region]
  ami                    = data.aws_ami.amazon_linux2.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private.*.id[count.index]
  tags                   = var.ec2_tags
  user_data              = file("scripts/nginx.sh")
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
}
