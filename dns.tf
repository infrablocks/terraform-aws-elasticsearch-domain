resource "aws_route53_record" "es_dns_private" {
  zone_id = "${var.dns_zone_id}"
  name    = "elasticsearch"
  type    = "CNAME"
  records = ["${aws_elasticsearch_domain.es.endpoint}"]
  ttl     = "600"
}
