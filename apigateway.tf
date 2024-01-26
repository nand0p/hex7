resource "aws_apigatewayv2_api" "hex7" {
  name               = var.product
  protocol_type      = "HTTP"
}


resource "aws_apigatewayv2_stage" "hex7" {
  api_id             = aws_apigatewayv2_api.hex7.id
  name               = var.product
  auto_deploy        = true

  access_log_settings {
    destination_arn  = aws_cloudwatch_log_group.hex7.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}


resource "aws_apigatewayv2_api_mapping" "hex7_com" {
  api_id             = aws_apigatewayv2_api.hex7.id
  domain_name        = aws_apigatewayv2_domain_name.hex7_com.id
  stage              = aws_apigatewayv2_stage.hex7.id
}


resource "aws_apigatewayv2_api_mapping" "www_hex7_com" {
  api_id             = aws_apigatewayv2_api.hex7.id
  domain_name        = aws_apigatewayv2_domain_name.www_hex7_com.id
  stage              = aws_apigatewayv2_stage.hex7.id
}


resource "aws_apigatewayv2_api_mapping" "hex7_net" {
  api_id             = aws_apigatewayv2_api.hex7.id
  domain_name        = aws_apigatewayv2_domain_name.hex7_net.id
  stage              = aws_apigatewayv2_stage.hex7.id
}


resource "aws_apigatewayv2_api_mapping" "www_hex7_net" {
  api_id             = aws_apigatewayv2_api.hex7.id
  domain_name        = aws_apigatewayv2_domain_name.www_hex7_net.id
  stage              = aws_apigatewayv2_stage.hex7.id
}


resource "aws_apigatewayv2_integration" "hex7" {
  api_id             = aws_apigatewayv2_api.hex7.id
  integration_uri    = aws_lambda_function.hex7.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}


resource "aws_apigatewayv2_route" "hex7" {
  api_id             = aws_apigatewayv2_api.hex7.id
  route_key          = "$default"
  target             = "integrations/${aws_apigatewayv2_integration.hex7.id}"
}


resource "aws_cloudwatch_log_group" "hex7" {
  name               = "/aws/${var.product}/${aws_apigatewayv2_api.hex7.name}"
  retention_in_days  = 30
}


resource "aws_lambda_permission" "api_gw" {
  statement_id       = "AllowExecutionFromAPIGateway"
  action             = "lambda:InvokeFunction"
  function_name      = aws_lambda_function.hex7.function_name
  principal          = "apigateway.amazonaws.com"
  source_arn         = "${aws_apigatewayv2_api.hex7.execution_arn}/*/*"
}
