
# Terraform AWS Application Load Balancer (ALB)

module "alb" {
  source = "terraform-aws-modules/alb/aws"

  version = "6.0.0"

  name               = "${var.component-name}-alb"
  load_balancer_type = "application"
  vpc_id             = local.vpc_id
  #subnets            = local.public_subnet.id

  security_groups = [aws_security_group.web.id]

  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]
  # Target Groups
  target_groups = [
    # App1 Target Group - TG Index = 0
    {
      name_prefix          = "app1"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/app1/index.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"

    },
    # App2 Target Group - TG Index = 1
    {
      name_prefix          = "app2"
      backend_protocol     = "HTTP"
      backend_port         = 8080
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/login"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"

    },
    # App3 Target Group - TG Index = 2
    {
      name_prefix          = "app3"
      backend_protocol     = "HTTP"
      backend_port         = 8080
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/login"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      stickiness = {
        enabled         = true
        cookie_duration = 86400
        type            = "lb_cookie"
      }
      protocol_version = "HTTP1"
      targets = {
        my_app3_vm1 = {
          target_id = try(aws_instance.web[0].id, "")
          port      = 8080
        },
        my_app3_vm2 = {
          target_id = try(aws_instance.web[1].id, "")
          port      = 8080
        }
      }

    }
  ]

  # HTTPS Listener
  https_listeners = [
    {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = module.acm.acm_certificate_arn
      action_type     = "fixed-response"
      fixed_response = {
        content_type = "text/plain"
        message_body = "Fixed Static message - for Root Context"
        status_code  = "200"
      }
    },
  ]
  https_listener_rules = [
    {
      https_listener_index = 0
      priority             = 1
      actions = [
        {
          type               = "forward"
          target_group_index = 0
        }
      ]
      conditions = [{
        path_patterns = ["/app1*"]
      }]
    },
    {
      https_listener_index = 0
      priority             = 2
      actions = [
        {
          type               = "forward"
          target_group_index = 1
        }
      ]
      conditions = [{
        path_patterns = ["/app2*"]
      }]
    },
    # Rule-3: /* should go to App3 - User-mgmt-WebApp EC2 Instances
    {
      https_listener_index = 0
      priority             = 3
      actions = [
        {
          type               = "forward"
          target_group_index = 2
        }
      ]
      conditions = [{
        path_patterns = ["/*"]
      }]
    },
  ]
}
/*resource "aws_lb" "kojitechs-lb" {
  name               = format("%s-%s", var.component-name, "kojitechs-lb")
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web.id]
  subnets            = aws_subnet.public_subnet.*.id # [for subnet in aws_subnet.public : subnet.id]

  tags = {
    Name = format("%s-%s", var.component-name, "kojitechs-lb")
  }
}

resource "aws_lb_target_group" "kojitechs_tg" {
   count                  = var.create_instance ? length(local.Name) : 0
  name     = format("%s-%s", var.component-name, "tg")
  port     = var.app_port
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    protocol            = "HTTP"
    matcher             = "200"
    path                = "/login"
    interval            = 30
  }

}


resource "aws_lb_listener" "front_end" {
  count = 1
  load_balancer_arn = aws_lb.kojitechs-lb.arn
  port              = var.https_port
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = module.acm.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.kojitechs_tg[count.index].arn
  }
}/*resource "aws_lb" "kojitechs-lb" {
  name               = format("%s-%s", var.component_name, "kojitechs-lb")
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web.id]
  subnets            = aws_subnet.public_subnet.*.id

  tags = {
    Name = format("%s-%s", var.component_name, "kojitechs-lb")
  }
}

resource "aws_lb_target_group" "register_app" {
  name     = format("%s-%s", var.component_name, "registerapp")
  port     = var.https_port
  protocol = "HTTP"
  vpc_id   = local.vpc_id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    protocol            = "HTTP"
    matcher             = "200"
    path                = "/login"
    interval            = 30
  }

}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.kojitechs-lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = module.acm.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.register_app.arn
  }
}
*/
