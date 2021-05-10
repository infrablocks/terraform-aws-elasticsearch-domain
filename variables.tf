variable "region" {}

variable "elastic_search_domain" {}


variable "dns_zone_id" {}

variable "subnet_ids" {
  type = "list"
}

variable "security_group_name" {}
variable "security_group_description" {}
variable "vpc_id" {}

variable "instance_type" {}
variable "instance_count" {}

variable "dedicated_master_enabled_count" {
  default = "false"
}

variable "zone_awareness_enabled" {
  default = "false"
}

variable "allow_explicit_index" {
  default = "true"
}

variable "volume_size" {
  default = "20"
}

variable "volume_type" {
  default = "gp2"
}

variable "encrypt_at_rest" {
  default = "false"
}

variable "automated_snapshot_start_hour" {
  default = "23"
}
