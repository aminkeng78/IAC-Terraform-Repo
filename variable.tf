# variable ami_id {
#     type = string
#     description = "ec2 instance ami id"
# }

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "ec2 instance type"
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "aws-region"
}