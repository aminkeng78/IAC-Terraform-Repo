
/*data "aws_ami" "goldeen_ami"{
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
*/
data "aws_ssm_parameter" "ami" {
  name = "latest_Golden_ami"
}

resource "aws_instance" "terrafom" {
  ami                         = data.aws_ssm_parameter.ami.value
  instance_type               = var.instance_type
  associate_public_ip_address = true
  user_data                   = file("${path.module}/app1-http.sh")
  vpc_security_group_ids      = [aws_security_group.allow_http.id]


}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  #vpc_id      = aws_vpc.main.id
  # http
  ingress {
    description = "http from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["73.133.14.137/32"]

  }
  # shh
  ingress {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["73.133.14.137/32"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }


}



