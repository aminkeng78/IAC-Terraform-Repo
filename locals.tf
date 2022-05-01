
locals {
  web_ingress_rules = [
    {
    description = "http traffic from port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

    },
    {
    description = "http traffic from port 80"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    },
    {
    description = "http traffic from port 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  egress_rule = [
    {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

    }
  ]

  web_server_ingress_rules = [ 
      {
    description     = "http from VPC"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    cidr_blocks     = ["73.133.14.137/32"]
    security_groups = [aws_security_group.web.id]   

  },
     {
    description     = "http from VPC"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["73.133.14.137/32"]
    security_groups = [aws_security_group.web.id]   

  }
  ]
  
  app_sg_ingress_rules = [
      {
    description     = "http from everywhere"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
      },
      {
    description     = "22 from web sg"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web_server.id]
      },
      {
    description     = "22 from web sg"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.web_server.id]  
      }
  ]

}
