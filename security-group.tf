resource "aws_security_group" "web" {
  name        = format("%s-%s", var.component-name, "web-sg")
  description = "Allow http inbound traffic"
  vpc_id      = local.vpc_id

  ingress {
    description = "http from VPC"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

resource "aws_security_group" "app" {
  name        = format("%s-%s", var.component-name, "app-sg")
  description = "Allow ssh inbound traffic"
  vpc_id      = local.vpc_id

  ingress {
    description     = "ssh"
    from_port       = var.ssh_port
    to_port         = var.ssh_port
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }
  #    ingress {
  #   description = "http from vpc"
  #   from_port   = 3306
  #   to_port     = 3306
  #   protocol    = "tcp"
  #   security_groups = [aws_security_group.db_sg.id]
  # }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}
resource "aws_security_group" "lb_sg" {
  name        = format("%s-%s", var.component-name, "lb-sg")
  description = "Allow inbound traffic from everywhere"
  vpc_id      = local.vpc_id

  ingress {
    description = "http from everywhere"
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "https from everywhere"
    from_port   = var.https_port
    to_port     = var.https_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}
