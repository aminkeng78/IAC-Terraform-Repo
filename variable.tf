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

variable "pub_subnetcidr" {
  type        = list(any)
  default     = ["10.0.0.0/24", "10.0.2.0/24"]
  description = "list of public cidr"
}
variable "private_subnetcidr" {
  type        = list(any)
  default     = ["10.0.1.0/24", "10.0.3.0/24"]
  description = "list of private cidr"
}
variable "database_subnetcidr" {
  type        = list(any)
  default     = ["10.0.5.0/24", "10.0.7.0/24"]
  description = "list of database cidr"
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