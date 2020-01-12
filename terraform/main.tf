terraform {
  backend "s3" {
    key = "terraform/terraform.tfstate"
  }
}

variable "domain_name" {
  type = "string"
}

provider "aws" {
  version = "~> 2.44.0"
}

provider "google" {
  version = "~> 3.4.0"
}

resource "aws_s3_bucket" "blog_images" {
  bucket = "images.${var.domain_name}"
  policy = "${data.aws_iam_policy_document.s3_policy.json}"
}

resource "aws_cloudfront_distribution" "images_distribution" {
  origin {
    domain_name = "${aws_s3_bucket.blog_images.bucket_domain_name}"
    origin_id   = "S3-images.${var.domain_name}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
    }
  }

  enabled = true
  comment = "Setting of origin to deliver S3."

  aliases = ["images.${var.domain_name}"]

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      cookies {
        forward = "none"
      }

      query_string = false
    }

    min_ttl     = 0
    max_ttl     = 86400 # 1 day, default 31536000 = 1 year
    default_ttl = 3600  # 1 hour, default 86400 = 1 day

    target_origin_id       = "S3-images.${var.domain_name}"
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "access-identity-images-distribution"
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::images.${var.domain_name}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::images.${var.domain_name}"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }
}
