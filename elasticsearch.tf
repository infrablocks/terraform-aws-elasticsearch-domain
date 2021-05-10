data "aws_caller_identity" "current" {}

resource "aws_elasticsearch_domain" "es" {
  domain_name           = "${var.elastic_search_domain}"
  elasticsearch_version = "6.3"

  cluster_config {
    instance_type            = "${var.instance_type}"
    instance_count           = "${var.instance_count}"
    dedicated_master_enabled = "${var.dedicated_master_enabled_count}"
    zone_awareness_enabled   = "${var.zone_awareness_enabled}"
  }

  vpc_options {
    security_group_ids = [
      "${aws_security_group.sg_elasticsearch.id}",
    ]

    subnet_ids = ["${var.subnet_ids}"]
  }

  advanced_options {
    "rest.action.multi.allow_explicit_index" = "${var.allow_explicit_index}"
  }

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
      "Resource": "arn:aws:es:${var.region}:${data.aws_caller_identity.current.account_id}:domain/${var.elastic_search_domain}/*"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "es:*",
      "Resource": "arn:aws:es:${var.region}:${data.aws_caller_identity.current.account_id}:domain/${var.elastic_search_domain}/*"
    }
  ]
}
CONFIG

  ebs_options {
    ebs_enabled = true
    volume_size = "${var.volume_size}"
    volume_type = "${var.volume_type}"
  }

  encrypt_at_rest {
    enabled = "${var.encrypt_at_rest}"
  }

  snapshot_options {
    automated_snapshot_start_hour = "${var.automated_snapshot_start_hour}"
  }

  tags {
    Domain = "${var.elastic_search_domain}"
  }
}
