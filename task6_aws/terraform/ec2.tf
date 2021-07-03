data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "main" {
  key_name   = "main"
  public_key = tls_private_key.main.public_key_openssh
}

resource "local_file" "ec2_private_key" {
  content  = tls_private_key.main.private_key_pem
  filename = "${path.module}/ec2_private_key.pem"
}

//EC2 Instances
resource "aws_instance" "compute_nodes" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = var.instance_type
  count                = length(var.azs)
  security_groups      = [aws_security_group.alb_sg.id]
  subnet_id            = element(module.vpc.public_subnets, count.index)
  key_name             = aws_key_pair.main.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  #user_data = filebase64("${path.module}/install.tpl")
  #data.template_file.user_data.rendered
  user_data = <<-EOF
                #!/bin/bash
                apt-get update -y
                apt install nginx -y
                systemctl start nginx
                aws s3 cp s3://task6-http/index.html /var/www/html/index.html
                EOF
  tags = {
    Name = "my-compute-node-${count.index}"
  }
}

# index.nginx-debian.html
#                 aws s3 cp s3://task6-http/index.html /var/www/html/index.html

//User data
# data "template_file" "user_data" {
#   template = file("install.tpl")
# }
