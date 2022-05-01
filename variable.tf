variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "aws-region"
}
variable "creatvpc" {
  type        = bool
  default     = "true"
  description = "creat vpc"
}
variable "create_instance" {
  type        = bool
  default     = "true"
  description = "creat instance"
}
variable "component-name" {
  default = "iac-terraform-repo"
}


variable "app_port" {
  default     = 8080
  type        = number
  description = "for app_port"
}


variable "http_port" {
  default     = 80
  type        = number
  description = ""
}
variable "https_port" {
  type        = number
  default     = 443
  description = ""
}
variable "ssh_port" {
  type        = number
  default     = 22
  description = ""
}
variable "database_name" {
  default     = "webappdb"
  description = "dbname"
}
variable "master_username" {
  default     = "dbadmin"
  description = "db user name"
}


variable "account_id" {
  type = map(any)
  default = {
    prod = "290566818138"
    sbx  = "848169424404"
  }
}

# variable "pub_az1" {
#   type = list
#   default = ["us-east-1a", "us-east-1b"]
#   description = "list of public az"
# }
# variable "private_az" {
#   type = list
#   default = ["us-east-1a", "us-east-1b"]
#   description = "list of private az"
# }
# variable "databas_az" {
#   type = list
#   default = ["us-east-1b", "us-east-1a"]
#   description = "list of database az"
# }