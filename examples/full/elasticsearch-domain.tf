module "elasticsearch_domain" {
  source = "../../"

  component = var.component
  deployment_identifier = var.deployment_identifier

  region = var.region
  vpc_id = module.base_network.vpc_id
  subnet_ids = module.base_network.private_subnet_ids

  allowed_cidrs = ["0.0.0.0/0"]
  egress_cidrs = ["10.0.0.0/8"]

  domain_name = var.domain_name
  public_zone_id = var.public_zone_id
  private_zone_id = var.private_zone_id

  elasticsearch_domain_name = "${var.component}-${var.deployment_identifier}"

  certificate_arn = module.acm_certificate.certificate_arn
}
