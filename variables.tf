variable "region" {
  description = "The region into which to deploy the load balancer."
  type = string
}
variable "vpc_id" {
  description = "The ID of the VPC into which to deploy the elasticsearch domain."
}
variable "subnet_ids" {
  description = "The IDs of the subnets for elasticsearch domain nodes."
  type = list(string)
}

variable "allowed_cidrs" {
  description = "A list of CIDRs from which the Elasticsearch domain is reachable."
  type = list(string)
}
variable "egress_cidrs" {
  description = "A list of CIDRs which the Elasticsearch domain can reach."
  type = list(string)
  default = []
}

variable "component" {
  description = "The component this elasticsearch domain will contain."
}
variable "deployment_identifier" {
  description = "An identifier for this elasticsearch domain."
}

variable "domain_name" {
  description = "The domain name of the supplied Route 53 zones."
  type = string
}
variable "public_zone_id" {
  description = "The ID of the public Route 53 zone."
  type = string
}
variable "private_zone_id" {
  description = "The ID of the private Route 53 zone."
  type = string
}

variable "elasticsearch_domain_name" {
  description = "The name of the Elasticsearch domain."
  type = string
}
variable "elasticsearch_volume_size" {
  description = "The size of the Elasticsearch EBS volume in GBs."
  default = 20
  type = number
}
variable "elasticsearch_volume_type" {
  description = "The type of the Elasticsearch EBS volume."
  default = "gp2"
  type = string
}

variable "elasticsearch_instance_type" {
  description = "The instance type of the Elasticsearch domain instances."
  default = "t3.small.elasticsearch"
  type = string
}
variable "elasticsearch_instance_count" {
  description = "The instance type of the Elasticsearch domain instances."
  default = 3
  type = number
}

variable "elasticsearch_advanced_options" {
  description = "A map of advanced options to set on the Elasticsearch domain."
  default = {}
  type = map(string)
}

variable "elasticsearch_automated_snapshot_start_hour" {
  description = "The hour to start taking automated snapshots"
  default = 23
  type = number
}

variable "include_public_dns_record" {
  description = "Whether or not to create a public DNS record (\"yes\" or \"no\")."
  type = string
  default = "no"
}
variable "include_private_dns_record" {
  description = "Whether or not to create a private DNS record (\"yes\" or \"no\")."
  type = string
  default = "yes"
}

variable "enable_dedicated_master_nodes" {
  description = "Whether or not to enable dedicated master nodes for the cluster (\"yes\" or \"no\")."
  type = string
  default = "no"
}

variable "enable_zone_awareness" {
  description = "Whether or not to enable zone awareness for the cluster (\"yes\" or \"no\")."
  type = string
  default = "no"
}

variable "enable_encryption_at_rest" {
  description = "Whether or not to enable encryption at rest for the Elasticsearch domain (\"yes\" or \"no\")."
  type = string
  default = "yes"
}
