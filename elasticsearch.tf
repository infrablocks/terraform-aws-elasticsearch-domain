data "aws_caller_identity" "current" {}

resource "aws_elasticsearch_domain" "elasticsearch" {
  domain_name           = var.elasticsearch_domain_name
  elasticsearch_version = "6.3"

  cluster_config {
    instance_type            = var.elasticsearch_instance_type
    instance_count           = var.elasticsearch_instance_count
    dedicated_master_enabled = var.enable_dedicated_master_nodes == "yes" ? true : false
    zone_awareness_enabled   = var.enable_zone_awareness == "yes" ? true : false

    dynamic "zone_awareness_config" {
      for_each = var.enable_zone_awareness == "yes" ? toset([length(var.subnet_ids)]) : toset([])

      content {
        availability_zone_count = zone_awareness_config.value
      }
    }
  }

  vpc_options {
    security_group_ids = [
      aws_security_group.elasticsearch.id,
    ]

    subnet_ids = var.subnet_ids
  }

  advanced_options = var.elasticsearch_advanced_options

  access_policies = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      "Action": "es:*",
      "Resource": "arn:aws:es:${var.region}:${data.aws_caller_identity.current.account_id}:domain/${var.elasticsearch_domain_name}/*"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "es:*",
      "Resource": "arn:aws:es:${var.region}:${data.aws_caller_identity.current.account_id}:domain/${var.elasticsearch_domain_name}/*"
    }
  ]
}
CONFIG

  ebs_options {
    ebs_enabled = true
    volume_size = var.elasticsearch_volume_size
    volume_type = var.elasticsearch_volume_type
  }

  encrypt_at_rest {
    enabled = var.enable_encryption_at_rest == "yes" ? true : false
  }

  snapshot_options {
    automated_snapshot_start_hour = var.elasticsearch_automated_snapshot_start_hour
  }

  depends_on = [
    aws_iam_service_linked_role.elasticsearch
  ]

  tags = {
    Domain = var.elasticsearch_domain_name
  }
}
