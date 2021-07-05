resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
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

resource "aws_key_pair" "main" {
  key_name   = "main"
  public_key = tls_private_key.main.public_key_openssh
}

resource "local_file" "ec2_private_key" {
  content  = tls_private_key.main.private_key_pem
  filename = "${path.module}/ec2_private_key.pem"
}

resource "aws_instance" "compute_nodes" {
  ami                  = data.aws_ami.amazon_linux2.id
  instance_type        = var.instance_type
  count                = length(var.azs)
  security_groups      = [aws_security_group.alb_sg.id]
  subnet_id            = element(module.vpc.public_subnets, count.index)
  key_name             = aws_key_pair.main.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  user_data            = filebase64("${path.module}/scripts/install.sh")
  tags = {
    Name = "my-compute-node-${count.index}"
  }
  depends_on = [
    aws_s3_bucket_object.file_upload
  ]
}
