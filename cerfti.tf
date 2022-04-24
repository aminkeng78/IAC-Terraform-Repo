
data "aws_route53_zone" "coniliuscf" {
  name = "coniliuscf.org"
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.coniliuscf.zone_id
  name    = "www.coniliuscf.org"
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

