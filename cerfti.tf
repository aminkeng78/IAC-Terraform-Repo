
data "aws_route53_zone" "coniliuscf" {
  name = "coniliuscf.org"
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "3.0.0"

  domain_name               = trimsuffix(data.aws_route53_zone.coniliuscf.name, ".")
  zone_id                   = data.aws_route53_zone.coniliuscf.zone_id
  subject_alternative_names = ["*.coniliuscf.org"]
}