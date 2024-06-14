locals {
  https_port = 443
}

resource "aws_lb" "main" {
  name            = "${local.name}-alb"
  subnets         = data.aws_subnet.public.*.id
  internal        = false
  security_groups = [aws_security_group.alb.id]

  load_balancer_type = "application"

  enable_deletion_protection = false
  drop_invalid_header_fields = true

}


resource "aws_lb_listener" "http" {
  port              = 80
  protocol          = "HTTP"
  load_balancer_arn = aws_lb.main.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_lb_target_group" "main" {
  name                 = "${local.name}-tg"
  port                 = 80
  vpc_id               = data.aws_vpc.main.id
  protocol             = "HTTP"
  slow_start           = 0
  target_type          = "ip"
  deregistration_delay = 10

  health_check {
    path                = "/"
    matcher             = "200-399"
    timeout             = 10
    interval            = 15
    healthy_threshold   = 2
    unhealthy_threshold = 8
  }

  lifecycle {
    create_before_destroy = true
  }
}
