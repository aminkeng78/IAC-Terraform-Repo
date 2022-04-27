    
data "aws_route53_zone" "coniliuscf" {
  name = lookup(var.dns_name, terraform.workspace)
}

variable "dns_name" {
  type = map
  default = {
    prod = "coniliuscf.org"
    sbx = "coniliuscf.org"
  } 
}

variable "dns_host_name" {
  type = map
  default = {
    prod = "www.coniliuscf.org"
    sbx = "www.coniliuscf.org"
  } 
}


resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.coniliuscf.zone_id
  name    = lookup(var.dns_host_name, terraform.workspace)
  type    = "A"

  alias {
    name                   = module.alb.lb_dns_name
    zone_id                = module.alb.lb_zone_id
    evaluate_target_health = true
  }
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "3.0.0"

  domain_name               = trimsuffix(data.aws_route53_zone.coniliuscf.name, ".")
  zone_id                   = data.aws_route53_zone.coniliuscf.zone_id
  subject_alternative_names = ["*.coniliuscf.org"]
}

