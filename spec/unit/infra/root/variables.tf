variable "region" {}

variable "component" {}
variable "deployment_identifier" {}

variable "allowed_cidrs" {
  type = list(string)
}
variable "egress_cidrs" {
  type = list(string)
  default = null
}

variable "domain_name" {}
variable "public_zone_id" {}
variable "private_zone_id" {}

variable "elasticsearch_domain_name" {}

variable "elasticsearch_volume_size" {
  type = number
  default = null
}
variable "elasticsearch_volume_type" {
  default = null
}

variable "elasticsearch_instance_type" {
  default = null
}
variable "elasticsearch_instance_count" {
  type = number
  default = null
}

variable "elasticsearch_advanced_options" {
  type = map(string)
  default = null
}

variable "elasticsearch_automated_snapshot_start_hour" {
  type = number
  default = null
}

variable "include_public_dns_record" {
  default = null
}
variable "include_private_dns_record" {
  default = null
}
variable "enable_dedicated_master_nodes" {
  default = null
}

variable "enable_zone_awareness" {
  default = null
}

variable "enable_encryption_at_rest" {
  default = null
}

variable "use_custom_certificate" {
  default = null
}
variable "certificate_arn" {
  default = null
}

variable "tls_security_policy" {
  default = null
}

variable "enforce_https" {
  default = null
}

variable "elasticsearch_version" {
  default = null
}
