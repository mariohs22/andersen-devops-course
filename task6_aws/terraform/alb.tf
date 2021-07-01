# Create Target group

resource "aws_lb_target_group" "myapp" {
  name     = "myapp-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.task6_vpc.id
}

# Attach EC2 instances to traget group

resource "aws_lb_target_group_attachment" "myapp" {
  count            = 2
  target_group_arn = aws_lb_target_group.myapp.arn
  target_id        = aws_instance.web.*.id[count.index]
  port             = 80
}

# Create ALB

resource "aws_lb" "myapp" {
  name               = "myapp-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.public.*.id

  enable_deletion_protection = false

  tags = {
    Environment = terraform.workspace
  }
}

# Configure ALB Listerner

resource "aws_lb_listener" "myapp" {
  load_balancer_arn = aws_lb.myapp.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.myapp.arn
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Allow inbound traffic for web applicaiton on ec2"
  vpc_id      = aws_vpc.task6_vpc.id

  ingress {
    description = "alb web port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "alb_sg"
  }
}
