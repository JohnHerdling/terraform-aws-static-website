terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Provider
provider "aws" {
  region = "eu-central-1" # Frankfurt
}

# S3-Bucket
data "aws_s3_bucket" "web" {
  bucket = "webside-bucket-cloudprogramming"
}

# Website
resource "aws_s3_object" "index" {
  bucket       = data.aws_s3_bucket.web.bucket
  key          = "index.html"
  content_type = "text/html"
  content = <<HTML
<!doctype html>
<html lang="de">
<head><meta charset="utf-8"><title>Hello Cloud</title></head>
<body style="font-family:system-ui;padding:2rem;">
  <h1>Hello World</h1>
  <p>Diese Seite läuft über S3 & CloudFront mit Terraform.</p>
</body>
</html>
HTML
}

# CloudFront + OAC 
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "webside-bucket-cloudprogramming-oac"
  description                       = "OAC for S3 webside-bucket-cloudprogramming"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  comment             = "Static site for webside-bucket-cloudprogramming"
  default_root_object = "index.html"
  price_class         = "PriceClass_100" 

  origin {
    domain_name              = data.aws_s3_bucket.web.bucket_regional_domain_name
    origin_id                = "s3-${data.aws_s3_bucket.web.id}"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  default_cache_behavior {
    target_origin_id       = "s3-${data.aws_s3_bucket.web.id}"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    forwarded_values {
      query_string = false
      cookies { forward = "none" }
    }
  }

  # Kein Geoblocking (weltweiter Zugriff möglich)
  restrictions {
    geo_restriction { restriction_type = "none" }
  }

  # CloudFront nutzt Standardzertifikat (*.cloudfront.net)
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  depends_on = [aws_s3_object.index]
}

# S3-Richtlinie
data "aws_iam_policy_document" "allow_cf_oac" {
  statement {
    sid     = "AllowCloudFrontServicePrincipalReadOnly"
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions   = ["s3:GetObject"]
    resources = ["${data.aws_s3_bucket.web.arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.cdn.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "allow_cf" {
  bucket = data.aws_s3_bucket.web.id
  policy = data.aws_iam_policy_document.allow_cf_oac.json
}

# Output
output "cloudfront_domain" {
  description = "HTTPS-URL meiner Website"
  value       = "https://${aws_cloudfront_distribution.cdn.domain_name}"
}
