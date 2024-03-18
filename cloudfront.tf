resource "aws_cloudfront_distribution" "hex7" {
  depends_on                 = [ aws_s3_object.hex7_index ]
  origin {
    domain_name              = aws_s3_bucket.hex7.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.hex7.id
    origin_id                = "hex7"
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "HEX7"
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.hex7_logs.bucket_domain_name
    prefix          = "cloudfront"
  }

  #aliases = ["www.hex7.com"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "hex7"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 60
    max_ttl                = 300
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = var.tags

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.hex7.arn
    ssl_support_method  = "sni-only"
  }

}

resource "aws_cloudfront_origin_access_control" "hex7" {
  name                              = "hex7"
  description                       = "Hex7 Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_s3_bucket" "hex7_logs" {
  bucket = "hex7.com-logs"
  tags = {
    Name = "CloudFront Logs Bucket"
  }
}

resource "aws_s3_bucket_ownership_controls" "hex7_logs" {
  bucket = aws_s3_bucket.hex7_logs.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "hex7_logs" {
  depends_on = [aws_s3_bucket_ownership_controls.hex7_logs]

  bucket = aws_s3_bucket.hex7_logs.id
  acl    = "log-delivery-write"
}
