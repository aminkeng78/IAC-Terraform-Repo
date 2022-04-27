# # fetching just one pub ip in the list
# output "public_ip" {
#   description = "public_ip"
#   value       = slice(aws_instance.terraform[*].public_ip, 0, 1)
#   sensitive   = false

# }

# # # fetching all pub ip in the list /// what if we want two pub ip in the list we use slice
# # output "public_ip2" {
# #   description = "public_ip"
# #   value       = aws_instance.terraform[*].public_ip
# #   sensitive   = false

# # }
# # output "public_dns" {
# #   description = "public_dns"
# #   value = aws_instance.terraform[*].public_dns
# #   sensitive = true
# # }
# #for loop with output
# output "ec2_arn" {
#   description = "arn"
#   value       = [for arn in aws_instance.terraform : arn.arn]
#   sensitive   = false
# }
output "public_ip" {
  value = aws_instance.web.*.public_ip
}

# output "dns_name" {
#   description = "cLICK on this link to connect to our application"
#   value       = format("https://%s", aws_route53_record.www.name)
# }