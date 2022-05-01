



resource "aws_security_group" "web" {
  name        = "${var.component-name}_web"
  description = "Allow ssh inbound traffic from Philo"
  vpc_id      = local.vpc_id

  dynamic "ingress"{
    for_each = local.web_ingress_rules
    
    content {
     description = ingress.value.description
    from_port   = ingress.value.from_port
    to_port     = ingress.value.to_port
    protocol    =ingress.value.protocol
    cidr_blocks = ingress.value.cidr_blocks
 
    }
  }
  dynamic "egress"{
    for_each = local.egress_rule
    iterator = foo
   content {
    from_port   = foo.value.from_port
    to_port     = foo.value.to_port
    protocol    = foo.value.protocol
    cidr_blocks = foo.value.cidr_blocks
    }
  }
  tags = {
    "Name" = "${var.component-name}_web"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "web_server" {
  name        = "${var.component-name}_web_server"
  description = "Allow shh inbound traffic from ${aws_security_group.web.id}"
  vpc_id      = local.vpc_id

  dynamic "ingress"{
    for_each = local.web_server_ingress_rules

   content {
     description = ingress.value.description
    from_port   = ingress.value.from_port
    to_port     = ingress.value.to_port
    protocol    =ingress.value.protocol
    cidr_blocks = ingress.value.cidr_blocks
    security_groups= ingress.value.security_groups

    }
  }

  dynamic "egress"{
    for_each = local.egress_rule
    iterator = foo
   content {
    from_port   = foo.value.from_port
    to_port     = foo.value.to_port
    protocol    = foo.value.protocol
    cidr_blocks = foo.value.cidr_blocks
    }
  }

  tags = {
    "Name" = "${var.component-name}_web_server"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "app_sg" {
  name        = "${var.component-name}_lb_sg"
  description = "Allow inbound traffic from everywhere"
  vpc_id      = local.vpc_id

  dynamic "ingress"{
    for_each = local.app_sg_ingress_rules

    content {
     description = ingress.value.description
    from_port   = ingress.value.from_port
    to_port     = ingress.value.to_port
    protocol    =ingress.value.protocol
    security_groups= ingress.value.security_groups

    }
  }

  dynamic "egress"{
    for_each = local.egress_rule
    iterator = foo
   content {
    from_port   = foo.value.from_port
    to_port     = foo.value.to_port
    protocol    = foo.value.protocol
    cidr_blocks = foo.value.cidr_blocks
    }
  }
  tags = {
    "Name" = "${var.component-name}_app_sg"
  }
  lifecycle {
    create_before_destroy = true
  }
}
