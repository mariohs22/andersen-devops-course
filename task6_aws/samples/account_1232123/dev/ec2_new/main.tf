
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

resource "aws_instance" "my_ec2_instance" {
  ami           = data.aws_ami.amazon_linux2.id
  instance_type = var.instance_type

  key_name               = aws_key_pair.this.key_name
  vpc_security_group_ids = [aws_security_group.this.id]
  subnet_id              = data.terraform_remote_state.vpc.outputs.vpc.public_subnets[0]
  
  associate_public_ip_address = true

  user_data = filebase64("${path.module}/templates/user_data.sh.tpl")

  tags = merge(
    local.tags,
    {
      Name = format("%s-my-ec2", local.prefix)
    }
  )
} 