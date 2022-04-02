
/*data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws" #https://github.com/terraform-aws-modules/terraform-aws-vpc.git

  name = "IAC.VP"
  cidr = "200.0.0.0/16"

  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnets = ["200.0.1.0/24", "200.0.2.0/24", "200.0.4.0/24" ,"200.0.6.0/24"]
  public_subnets  = ["200.0.101.0/24", "200.0.103.0/24", "200.0.105.0/24", "200.0.107.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false
}
*/