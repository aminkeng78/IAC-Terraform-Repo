
terraform workspace list
terraform workspace new
 terraform apply -var-file="prod.tfvars"
 terraform destroy -var-file="dev.tfvars
 terraform workspace select
 # terraform.workspace == "dev" && terraform.workspace == "sbx" ? 1 : 0
# terraform.workspace !="prod" ? 1 : 0
# -var-file
# tfvars
# prod.tfvars 
# dbs.tfvars 
# dev.tfvars
# NOTE ALWAYS CHECK WHAT WORKSPACE U ARE CONNECTED TO
# >    terraform workspace show 
/*
"dev" == "prod"
"sbx" == "prod"
"prod" == "prod" = 0
terraform.workspace !="prod" ? 1 : 0

*/