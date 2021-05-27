variable "region" {}

variable "component" {}
variable "deployment_identifier" {}

variable "allowed_cidrs" {
  type = list(string)
}
variable "egress_cidrs" {
  type = list(string)
}

variable "domain_name" {}
variable "public_zone_id" {}
variable "private_zone_id" {}

variable "elasticsearch_domain_name" {}
