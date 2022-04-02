# variable ami_id {
#     type = string
#     description = "ec2 instance ami id"
# }

variable "instance_type" {
  type        = list(any)
  default     = ["t2.micro", "t3.micro"]
  description = "ec2 instance type"
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "aws-region"
}

variable "ingress_cidr" {
  description = "the CIRD block for SG"
  type        = list(any)
  default     = ["73.133.14.137/32"]
}
variable "assign_public_ip" {
  type        = bool
  default     = true
  description = "associate_public_ip_address"

}
variable "creat_instance" {
  type        = bool
  default     = true
  description = "Creat instance"
}