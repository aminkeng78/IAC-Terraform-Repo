
variable "s3_cfname" {
    type = list
    description = "for my s3 bucket"
}
variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "aws-region"
}
variable "component-name" {
  default = "iac-terraform-repo"
}