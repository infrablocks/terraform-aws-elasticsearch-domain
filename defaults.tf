locals {
  # default for cases when `null` value provided, meaning "use default"
  egress_cidrs                                = var.egress_cidrs == null ? [] : var.egress_cidrs
  elasticsearch_volume_size                   = var.elasticsearch_volume_size == null ? 20 : var.elasticsearch_volume_size
  elasticsearch_volume_type                   = var.elasticsearch_volume_type == null ? "gp2" : var.elasticsearch_volume_type
  elasticsearch_instance_type                 = var.elasticsearch_instance_type == null ? "t3.small.elasticsearch" : var.elasticsearch_instance_type
  elasticsearch_instance_count                = var.elasticsearch_instance_count == null ? 3 : var.elasticsearch_instance_count
  elasticsearch_advanced_options              = var.elasticsearch_advanced_options == null ? {} : var.elasticsearch_advanced_options
  elasticsearch_automated_snapshot_start_hour = var.elasticsearch_automated_snapshot_start_hour == null ? 23 : var.elasticsearch_automated_snapshot_start_hour
  include_public_dns_record                   = var.include_public_dns_record == null ? "no" : var.include_public_dns_record
  include_private_dns_record                  = var.include_private_dns_record == null ? "yes" : var.include_private_dns_record
  enable_dedicated_master_nodes               = var.enable_dedicated_master_nodes == null ? "no" : var.enable_dedicated_master_nodes
  enable_zone_awareness                       = var.enable_zone_awareness == null ? "yes" : var.enable_zone_awareness
  enable_encryption_at_rest                   = var.enable_encryption_at_rest == null ? "yes" : var.enable_encryption_at_rest
  use_custom_certificate                      = var.use_custom_certificate == null ? "yes" : var.use_custom_certificate
  certificate_arn                             = var.certificate_arn == null ? "" : var.certificate_arn
  tls_security_policy                         = var.tls_security_policy == null ? "Policy-Min-TLS-1-2-2019-07" : var.tls_security_policy
  enforce_https                               = var.enforce_https == null ? true : var.enforce_https
  elasticsearch_version                       = var.elasticsearch_version == null ? "6.3" : var.elasticsearch_version
}
