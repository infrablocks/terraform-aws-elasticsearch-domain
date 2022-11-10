output "vpc_id" {
  value = module.base_network.vpc_id
}

output "vpc_cidr" {
  value = module.base_network.vpc_cidr
}

output "public_subnet_ids" {
  value = module.base_network.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.base_network.private_subnet_ids
}

output "certificate_arn" {
  value = module.acm_certificate.certificate_arn
}
output "elasticsearch_domain_arn" {
  value = module.elasticsearch_domain.elasticsearch_domain_arn
}

output "elasticsearch_domain_name" {
  value = module.elasticsearch_domain.elasticsearch_domain_name
}

output "elasticsearch_domain_address" {
  value = module.elasticsearch_domain.elasticsearch_domain_address
}

output "elasticsearch_domain_endpoint" {
  value = module.elasticsearch_domain.elasticsearch_domain_endpoint
}

output "elasticsearch_domain_kibana_endpoint" {
  value = module.elasticsearch_domain.elasticsearch_domain_kibana_endpoint
}

output "elasticsearch_domain_security_group_id" {
  value = module.elasticsearch_domain.elasticsearch_domain_security_group_id
}

output "elasticsearch_domain_security_group_arn" {
  value = module.elasticsearch_domain.elasticsearch_domain_security_group_arn
}
