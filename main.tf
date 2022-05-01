

data "terraform_remote_state" "operational_environment" {
  backend  = "s3"

  config = {
    region = "us-east-1"
    bucket =  "koljitechs.vpcstatebuckets"
    key = format("env:/%s/terraform.tfstate", lower(terraform.workspace))
  }
}

locals {
  operational_environment = data.terraform_remote_state.operational_environment.outputs
  vpc_id = local.operational_environment.vpc_id
  pub_subnet_ids = local.operational_environment.pub_subnet
  private_subnet_ids = local.operational_environment.private_subnet
  data_subnet_ids = local.operational_environment.database_subnet
  pub_subnet_cidrs = local.operational_environment.pub_subnet_cidr
}

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
