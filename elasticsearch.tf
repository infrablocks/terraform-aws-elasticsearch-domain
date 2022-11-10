data "aws_caller_identity" "current" {}

// TODO: Work out if the wildcard access is really needed
data "aws_iam_policy_document" "aws_access" {
  statement {
    sid = "AllowIAMToAccessElasticsearchDomain"
    effect  = "Allow"
    actions = ["es:*"]
    principals {
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
      type = "AWS"
    }
    resources = [
      "arn:aws:es:${var.region}:${data.aws_caller_identity.current.account_id}:domain/${var.elasticsearch_domain_name}/*"
    ]
  }
  statement {
    sid = "AllowAWSEntitiesToAccessElasticsearchDomain"
    effect  = "Allow"
    actions = ["es:*"]
    principals {
      identifiers = [
        "*"
      ]
      type = "AWS"
    }
    resources = [
      "arn:aws:es:${var.region}:${data.aws_caller_identity.current.account_id}:domain/${var.elasticsearch_domain_name}/*"
    ]
  }
}

resource "aws_elasticsearch_domain" "elasticsearch" {
  domain_name           = var.elasticsearch_domain_name
  elasticsearch_version = local.elasticsearch_version

  cluster_config {
    instance_type            = local.elasticsearch_instance_type
    instance_count           = local.elasticsearch_instance_count
    dedicated_master_enabled = local.enable_dedicated_master_nodes == "yes" ? true : false
    zone_awareness_enabled   = local.enable_zone_awareness == "yes" ? true : false

    dynamic "zone_awareness_config" {
      for_each = local.enable_zone_awareness == "yes" ? toset([
        length(var.subnet_ids)
      ]) : toset([])

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

  advanced_options = local.elasticsearch_advanced_options

  access_policies = data.aws_iam_policy_document.aws_access.json

  ebs_options {
    ebs_enabled = true
    volume_size = local.elasticsearch_volume_size
    volume_type = local.elasticsearch_volume_type
  }

  encrypt_at_rest {
    enabled = local.enable_encryption_at_rest == "yes" ? true : false
  }

  dynamic "domain_endpoint_options" {
    for_each = local.use_custom_certificate == "yes" ? [1] : []
    content {
      custom_endpoint_certificate_arn = local.certificate_arn
      enforce_https                   = local.enforce_https
      tls_security_policy             = local.tls_security_policy
      custom_endpoint_enabled         = true
      custom_endpoint                 = local.address
    }
  }

  snapshot_options {
    automated_snapshot_start_hour = local.elasticsearch_automated_snapshot_start_hour
  }

  depends_on = [
    aws_iam_service_linked_role.elasticsearch
  ]

  tags = {
    Domain = var.elasticsearch_domain_name
  }
}
