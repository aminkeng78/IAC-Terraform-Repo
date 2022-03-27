
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
    component_name          = "IAC-TERRAFORM-REPO"

  }
}