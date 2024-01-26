output "s3" {
  value = aws_s3_bucket.hex7.id
} 

output "lambda" {
  value = aws_lambda_function.hex7.function_name
}

output "api_gateway" {
  value = aws_apigatewayv2_stage.hex7.invoke_url
}

#output "lambda_url" {
#  value = aws_lambda_function_url.hex7.function_url
#}
