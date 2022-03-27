
output "public_ip" {
  description = "public_ip"
  value       = "aws_instance.terraform.public_ip"
  sensitive   = false

}