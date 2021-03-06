provider "fastly" {
  # We only want to use fastly's data API
  api_key = "test"
}

data "fastly_ip_ranges" "fastly" {}

data "external" "pingdom" {
  program = ["/bin/bash", "${path.module}/pingdom_probe_ips.sh"]
}

data "aws_iam_policy_document" "s3_mirror_read_policy_doc" {
  statement {
    sid     = "S3FastlyReadBucket"
    actions = ["s3:GetObject"]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.govuk-mirror.id}",
      "arn:aws:s3:::${aws_s3_bucket.govuk-mirror.id}/*",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = ["${data.fastly_ip_ranges.fastly.cidr_blocks}"]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }

  statement {
    sid     = "S3PingdomReadBucket"
    actions = ["s3:GetObject"]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.govuk-mirror.id}",
      "arn:aws:s3:::${aws_s3_bucket.govuk-mirror.id}/*",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = ["${split(",",data.external.pingdom.result.pingdom_probe_ips)}"]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }

  statement {
    sid     = "S3OfficeReadBucket"
    actions = ["s3:GetObject"]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.govuk-mirror.id}",
      "arn:aws:s3:::${aws_s3_bucket.govuk-mirror.id}/*",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = ["${var.office_ips}"]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }

  statement {
    sid     = "S3NATInternalReadBucket"
    actions = ["s3:GetObject"]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.govuk-mirror.id}",
      "arn:aws:s3:::${aws_s3_bucket.govuk-mirror.id}/*",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = ["${data.terraform_remote_state.infra_networking.nat_gateway_elastic_ips_list}"]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }

  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.govuk-mirror.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.mirror_access_identity.iam_arn}"]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["${aws_s3_bucket.govuk-mirror.arn}"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.mirror_access_identity.iam_arn}"]
    }
  }
}

data "aws_iam_policy_document" "s3_mirror_replica_read_policy_doc" {
  statement {
    sid     = "S3FastlyReadBucket"
    actions = ["s3:GetObject"]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.govuk-mirror-replica.id}",
      "arn:aws:s3:::${aws_s3_bucket.govuk-mirror-replica.id}/*",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = ["${data.fastly_ip_ranges.fastly.cidr_blocks}"]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }

  statement {
    sid     = "S3PingdomReadBucket"
    actions = ["s3:GetObject"]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.govuk-mirror-replica.id}",
      "arn:aws:s3:::${aws_s3_bucket.govuk-mirror-replica.id}/*",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = ["${split(",",data.external.pingdom.result.pingdom_probe_ips)}"]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }

  statement {
    sid     = "S3OfficeReadBucket"
    actions = ["s3:GetObject"]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.govuk-mirror-replica.id}",
      "arn:aws:s3:::${aws_s3_bucket.govuk-mirror-replica.id}/*",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = ["${var.office_ips}"]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }

  statement {
    sid     = "S3NATInternalReadBucket"
    actions = ["s3:GetObject"]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.govuk-mirror-replica.id}",
      "arn:aws:s3:::${aws_s3_bucket.govuk-mirror-replica.id}/*",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = ["${data.terraform_remote_state.infra_networking.nat_gateway_elastic_ips_list}"]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}
