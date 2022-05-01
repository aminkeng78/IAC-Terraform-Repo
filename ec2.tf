                               

locals {

  Name      = ["app1_instance", "app2_instance"]
  mysql = jsondecode(data.aws_secretsmanager_secret_version.mysecret.secret_string)

}


data "aws_secretsmanager_secret_version" "mysecret" {
  secret_id = module.aurora.secrets_version
}


data "aws_ami" "amzlinux2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "web" {
  depends_on             = [module.aurora]

  count                  = var.create_instance ? length(local.Name) : 0
  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = "t2.micro"
  subnet_id              = element(slice(local.private_subnet_ids, 0,  length(local.Name)), count.index)
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  key_name               = aws_key_pair.bastion_instance.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  user_data = templatefile("${path.module}/template/registrationapp.tmpl",

    {
      endpoint    = local.mysql["endpoint"]
      port        = local.mysql["port"]
      db_name     = local.mysql["dbname"]
      db_user     = local.mysql["username"]
      db_password = local.mysql["password"]
    }

  )

  tags = {
    Name = local.Name[count.index]
  }
  lifecycle {
    ignore_changes = [
      user_data,
    ]
  }
}

# Lifecycle policies
# Create before destroy 
# prevent destroy 
# ignore changes

resource "aws_key_pair" "bastion_instance" {
  key_name   = "bastion_instance"
  public_key = file("./template/bastion_instance.pub")
}


resource "aws_ssm_parameter" "ssm_kp" {
  name  = format("%s-%s", var.component-name, "ssm-kp")
  type  = "SecureString"
  value = " "

  lifecycle {
    ignore_changes = [
      value,
    ]
  }

}

