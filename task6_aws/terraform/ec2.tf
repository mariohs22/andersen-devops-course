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
  ami           = data.aws_ami.amazon_linux2.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.private.*.id[count.index]
  tags          = var.ec2_tags
  #user_data              = filebase64("${path.module}/scripts/nginx.sh.tpl") # file("scripts/nginx.sh")
  # user_data              = <<-EOF
  #                           #!/bin/bash
  #                           sudo amazon-linux-extras install nginx1 -y
  #                         EOF
  user_data = <<EOT
#cloud-config
# update apt on boot
package_update: true
# install nginx
packages:
- nginx
write_files:
- content: |
    <!DOCTYPE html>
    <html>
    <head>
      <title>StackPath - Amazon Web Services Instance</title>
      <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
      <style>
        html, body {
          background: #000;
          height: 100%;
          width: 100%;
          padding: 0;
          margin: 0;
          display: flex;
          justify-content: center;
          align-items: center;
          flex-flow: column;
        }
        img { width: 250px; }
        svg { padding: 0 40px; }
        p {
          color: #fff;
          font-family: 'Courier New', Courier, monospace;
          text-align: center;
          padding: 10px 30px;
        }
      </style>
    </head>
    <body>
      <img src="https://www.stackpath.com/content/images/logo-and-branding/stackpath-logo-standard-screen.svg">
      <p>This request was proxied from <strong>Amazon Web Services</strong></p>
    </body>
    </html>
  path: /usr/share/app/index.html
  permissions: '0644'
runcmd:
- cp /usr/share/app/index.html /usr/share/nginx/html/index.html
EOT

  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
}
