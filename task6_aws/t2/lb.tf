resource "aws_lb" "lb-nginx" {
  name               = "nginx-load-balancer"
  internal           = false
  load_balancer_type = "network"
  subnets            = aws_subnet.subnet.*.id
  depends_on         = [aws_instance.instance]

  tags = local.tags
}

resource "aws_lb_target_group" "lb-nginx-tg" {
  name        = "lb-nginx-tg"
  port        = 80
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = aws_vpc.vpc.id
  health_check {
    interval            = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "lb-nginx-tg-attach-0" {
  target_group_arn = aws_lb_target_group.lb-nginx-tg.arn
  target_id        = aws_instance.instance.0.id
  port             = 80
}
resource "aws_lb_target_group_attachment" "lb-nginx-tg-attach-1" {
  target_group_arn = aws_lb_target_group.lb-nginx-tg.arn
  target_id        = aws_instance.instance.1.id
  port             = 80
}

resource "aws_lb_listener" "lb-nginx" {
  load_balancer_arn = aws_lb.lb-nginx.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb-nginx-tg.arn
  }
}
