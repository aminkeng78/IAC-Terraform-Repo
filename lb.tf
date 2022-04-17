resource "aws_lb" "kojitechs-lb" {
  name               = format("%s-%s", var.component-name, "kojitechs-lb")
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = aws_subnet.public_subnet.*.id # [for subnet in aws_subnet.public : subnet.id]

  tags = {
    Name = format("%s-%s", var.component-name, "kojitechs-lb")
  }
}
resource "aws_lb_target_group" "kojitechs_tg" {
  name     = format("%s-%s", var.component-name, "tg")
  port     = var.http_port
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    protocol            = "HTTP"
    matcher             = "200"
    path                = "/"
    interval            = 30
  }

}
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.kojitechs-lb.arn
  port              = var.https_port
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = module.acm.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.kojitechs_tg.arn
  }
}

