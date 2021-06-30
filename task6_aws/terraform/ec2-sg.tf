resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Allow inbound traffic for web applicaiton on ec2"
  vpc_id      = aws_vpc.task6_vpc.id

  ingress {
    description = "web port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.task6_vpc.cidr_block]
  }
  ingress {
    description = "ssh port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.task6_vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2_sg"
  }
}
