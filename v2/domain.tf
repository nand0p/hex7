resource "aws_apigatewayv2_domain_name" "hex7_com" {
  domain_name = "${var.product}.com"

  domain_name_configuration {
    certificate_arn = aws_acm_certificate.hex7.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}


resource "aws_apigatewayv2_domain_name" "www_hex7_com" {
  domain_name = "www.${var.product}.com"

  domain_name_configuration {
    certificate_arn = aws_acm_certificate.hex7.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}


resource "aws_apigatewayv2_domain_name" "hex7_net" {
  domain_name = "${var.product}.net"

  domain_name_configuration {
    certificate_arn = aws_acm_certificate.hex7.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}


resource "aws_apigatewayv2_domain_name" "www_hex7_net" {
  domain_name = "www.${var.product}.net"

  domain_name_configuration {
    certificate_arn = aws_acm_certificate.hex7.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}


resource "aws_route53_record" "hex7_com" {
  name    = aws_apigatewayv2_domain_name.hex7_com.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.hex7_com.zone_id

  alias {
    name                   = aws_apigatewayv2_domain_name.hex7_com.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.hex7_com.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}


resource "aws_route53_record" "www_hex7_com" {
  name    = aws_apigatewayv2_domain_name.www_hex7_com.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.hex7_com.zone_id

  alias {
    name                   = aws_apigatewayv2_domain_name.www_hex7_com.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.www_hex7_com.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}


resource "aws_route53_record" "hex7_net" {
  name    = aws_apigatewayv2_domain_name.hex7_net.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.hex7_net.zone_id

  alias {
    name                   = aws_apigatewayv2_domain_name.hex7_net.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.hex7_net.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}


resource "aws_route53_record" "www_hex7_net" {
  name    = aws_apigatewayv2_domain_name.www_hex7_net.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.hex7_net.zone_id

  alias {
    name                   = aws_apigatewayv2_domain_name.www_hex7_net.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.www_hex7_net.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}


data "aws_route53_zone" "hex7_com" {
  name         = "${var.product}.com."
  private_zone = false
}


data "aws_route53_zone" "hex7_net" {
  name         = "${var.product}.net."
  private_zone = false
}


resource "aws_acm_certificate" "hex7" {
  domain_name       = "www.${var.product}.com"
  validation_method = "EMAIL"
  subject_alternative_names = [ "hex7.com", "hex7.net", "www.hex7.net" ]

  validation_option {
    domain_name       = "www.${var.product}.com"
    validation_domain = "${var.product}.com"
  }
}
