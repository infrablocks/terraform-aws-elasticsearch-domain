data "terraform_remote_state" "prerequisites" {
  backend = "local"

  config = {
    path = "${path.module}/../../../../state/prerequisites.tfstate"
  }
}

module "elasticsearch_domain" {
  source = "../../../.."

  component = var.component
  deployment_identifier = var.deployment_identifier

  region = var.region
  vpc_id = data.terraform_remote_state.prerequisites.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.prerequisites.outputs.private_subnet_ids

  allowed_cidrs = var.allowed_cidrs
  egress_cidrs = var.egress_cidrs

  domain_name = var.domain_name
  public_zone_id = var.public_zone_id
  private_zone_id = var.private_zone_id

  elasticsearch_domain_name = var.elasticsearch_domain_name
  elasticsearch_version = var.elasticsearch_version
  elasticsearch_instance_type = var.elasticsearch_instance_type
  elasticsearch_instance_count = var.elasticsearch_instance_count
  elasticsearch_volume_size = var.elasticsearch_volume_size
  elasticsearch_volume_type = var.elasticsearch_volume_type
  elasticsearch_advanced_options = var.elasticsearch_advanced_options
  elasticsearch_automated_snapshot_start_hour = var.elasticsearch_automated_snapshot_start_hour

  enable_dedicated_master_nodes = var.enable_dedicated_master_nodes
  enable_zone_awareness = var.enable_zone_awareness
  enable_encryption_at_rest = var.enable_encryption_at_rest

  use_custom_certificate = var.use_custom_certificate
  certificate_arn = var.certificate_arn
  enforce_https = var.enforce_https
  tls_security_policy = var.tls_security_policy

  include_public_dns_record = var.include_public_dns_record
  include_private_dns_record = var.include_private_dns_record
}
