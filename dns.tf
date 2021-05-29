locals {
  address = "${var.component}-${var.deployment_identifier}.${var.domain_name}"
}

resource "aws_route53_record" "elasticsearch_public" {
  zone_id = var.public_zone_id
  name    = local.address
  type    = "CNAME"
  ttl     = 60

  records = [aws_elasticsearch_domain.elasticsearch.endpoint]

  count = var.include_public_dns_record == "yes" ? 1 : 0
}

resource "aws_route53_record" "elasticsearch_private" {
  zone_id = var.private_zone_id
  name    = local.address
  type    = "CNAME"
  ttl     = 60

  records = [aws_elasticsearch_domain.elasticsearch.endpoint]

  count = var.include_private_dns_record == "yes" ? 1 : 0
}
