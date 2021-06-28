resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_ssm_parameter" "this" {
  name        = format("%s/ec2/key_pem", local.ssm_prefix)
  description = "My key-pair private key"
  type        = "SecureString"
  value       = tls_private_key.this.private_key_pem
}

resource "aws_key_pair" "this" {
  key_name   = format("%s-ec2", local.prefix)
  public_key = tls_private_key.this.public_key_openssh
}

