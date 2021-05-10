output "elastic_search_domain" {
  value = "${aws_elasticsearch_domain.es.domain_name}"
}

output "elastic_search_endpoint" {
  value = "${aws_elasticsearch_domain.es.endpoint}"
}

output "elastic_search_private_dns" {
  value = "${aws_route53_record.es_dns_private.fqdn}"
}

output "elastic_search_kibana_endpoint" {
  value = "${aws_elasticsearch_domain.es.kibana_endpoint}"
}

output "elastic_search_security_group_id" {
  value = "${aws_security_group.sg_elasticsearch.id}"
}
