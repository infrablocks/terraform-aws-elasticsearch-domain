output "elasticsearch_domain_arn" {
  value = aws_elasticsearch_domain.elasticsearch.arn
}

output "elasticsearch_domain_name" {
  value = aws_elasticsearch_domain.elasticsearch.domain_name
}

output "elasticsearch_domain_address" {
  value = local.address
}

output "elasticsearch_domain_endpoint" {
  value = aws_elasticsearch_domain.elasticsearch.endpoint
}

output "elasticsearch_domain_kibana_endpoint" {
  value = aws_elasticsearch_domain.elasticsearch.kibana_endpoint
}

output "elasticsearch_domain_security_group_id" {
  value = aws_security_group.elasticsearch.id
}

output "elasticsearch_domain_security_group_arn" {
  value = aws_security_group.elasticsearch.arn
}
