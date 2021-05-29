data "aws_vpc" "network" {
  id = var.vpc_id
}

resource "aws_security_group" "elasticsearch" {
  name        = "es-${var.component}-${var.deployment_identifier}"
  vpc_id      = var.vpc_id
  description = "Elasticsearch domain for component: ${var.component}, domain: ${var.elasticsearch_domain_name}, deployment: ${var.deployment_identifier}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.allowed_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = coalescelist(var.egress_cidrs, [data.aws_vpc.network.cidr_block])
  }
}
