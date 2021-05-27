data "terraform_remote_state" "prerequisites" {
  backend = "local"

  config = {
    path = "${path.module}/../../../../state/prerequisites.tfstate"
  }
}

module "elasticsearch_domain" {
  # This makes absolutely no sense. I think there's a bug in terraform.
  source = "./../../../../../../../"

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
  elasticsearch_instance_count = var.elasticsearch_instance_count
}
