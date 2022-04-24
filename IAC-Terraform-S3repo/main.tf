
locals {
  mandatory_tag = {
    line_of_business        = "terrafom"
    ado                     = "app"
    tier                    = "WEB"
    operational_environment = upper(terraform.workspace)
    tech_poc_primary        = "aminkengc78@gmail.com"
    tech_poc_secondary      = "aminkengc78@gmail.com"
    application             = "http"
    builder                 = "aminkengc78@gmail.com"
    application_owner       = "kojitechs.com"
    vpc                     = "WEB"
    cell_name               = "WEB"
    component_name          = var.component-name

  }
}


resource "aws_s3_bucket" "iacs3_bucket" {
    count                  = length(var.s3_name)
  bucket = var.s3_name[count.index]
   versioning {
    enabled = true
  }

    lifecycle {
    prevent_destroy = true
  }
  tags = {
    Name        = var.s3_name[count.index]
  }
}


resource "aws_dynamodb_table" "dynamodb-terraform-lock" {
  name           = "terraform-lock"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  lifecycle {
    prevent_destroy = true
  }

  attribute {
    name = "LockID"
    type = "S"
  }
}
