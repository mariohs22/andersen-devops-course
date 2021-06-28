resource "aws_security_group" "this" {
  name        = format("%s-my-ec2", local.prefix)
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    local.tags,
    {
      Name = format("%s-my-ec2", local.prefix)
    }
  )
}

resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [var.cidr_to_allow]
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.cidr_to_allow]
  security_group_id = aws_security_group.this.id
}