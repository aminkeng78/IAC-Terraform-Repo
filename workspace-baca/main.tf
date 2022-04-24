terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

terraform {

  backend "s3" {
    bucket         =  "workspace.baca.demo"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
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
/*
"dev" == "prod"
"sbx" == "prod"
"prod" == "prod" = 0
terraform.workspace !="prod" ? 1 : 0

*/

resource "aws_instance" "web" {
    count = terraform.workspace !="prod" ? 1 : 0
  ami           = data.aws_ami.amzlinux2.id
  instance_type = var.instance_type

  tags = {
    Name = format("%s_%s", "web", terraform.workspace)
  }
}
# terraform.workspace == "dev" && terraform.workspace == "sbx" ? 1 : 0
# terraform.workspace !="prod" ? 1 : 0
# -var-file
# tfvars
# prod.tfvars 
# dbs.tfvars 
# dev.tfvars
# NOTE ALWAYS CHECK WHAT WORKSPACE U ARE CONNECTED TO
# >    terraform workspace show 