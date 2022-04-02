
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
resource "random_integer" "random" {
  min = 1
  max = 20

}


data "aws_ssm_parameter" "ami" {
  name = "latest_Golden_ami"
}
# count is mostly use for condition
resource "aws_instance" "terraform" {
  count                       = var.creat_instance ? 1 : 0
  ami                         = data.aws_ssm_parameter.ami.value
  instance_type               = var.instance_type
  associate_public_ip_address = var.assign_public_ip
  user_data                   = file("${path.module}/app1-http.sh")
  vpc_security_group_ids      = [aws_security_group.allow_http.id]

  # tags_all = {
  #   Name = "terraform-${random_integer.random}"
  # }


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
    cidr_blocks = var.ingress_cidr

  }
  # shh
  ingress {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr

  }
  ingress {
    description = "https from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr

  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }


}



