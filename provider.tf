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
  region  = var.aws_region
  assume_role {
    role_arn = "arn:aws:iam::${lookup(var.account_id, terraform.workspace)}:role/Terraform_assumeRole"
  }
  default_tags {
    tags = local.mandatory_tag
  }
}

terraform {

  backend "s3" {
    bucket         = "iacs3.bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}



