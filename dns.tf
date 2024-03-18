data "aws_route53_zone" "hex7_com" {
  name = "${var.product}.com."
}

data "aws_route53_zone" "hex7_net" {
  name = "${var.product}.net."
}

resource "aws_route53_record" "hex7_com_root" {
  zone_id = data.aws_route53_zone.hex7_com.zone_id
  name    = "${var.product}.com."
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.hex7.domain_name
    zone_id                = aws_cloudfront_distribution.hex7.hosted_zone_id
    evaluate_target_health = true
  }
}
resource "aws_route53_record" "hex7_net_root" {
  zone_id = data.aws_route53_zone.hex7_net.zone_id
  name    = "${var.product}.net."
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.hex7.domain_name
    zone_id                = aws_cloudfront_distribution.hex7.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "hex7_com_www" {
  zone_id = data.aws_route53_zone.hex7_com.zone_id
  name    = "www.${var.product}.com."
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.hex7.domain_name
    zone_id                = aws_cloudfront_distribution.hex7.hosted_zone_id
    evaluate_target_health = true
  }
}


resource "aws_route53_record" "hex7_net_www" {
  zone_id = data.aws_route53_zone.hex7_net.zone_id
  name    = "www.${var.product}.net."
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.hex7.domain_name
    zone_id                = aws_cloudfront_distribution.hex7.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_acm_certificate" "hex7" {
  domain_name       = "www.${var.product}.com"
  validation_method = "EMAIL"
  subject_alternative_names = [ "${var.product}.com", "${var.product}.net", "www.${var.product}.net" ]

  validation_option {
    domain_name       = "www.${var.product}.com"
    validation_domain = "${var.product}.com"
  }
}
