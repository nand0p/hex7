data "archive_file" "hex7" {
  type               = "zip"
  source_dir         = "${path.module}/${var.product}"
  output_path        = "${path.module}/${var.product}.zip"
}


resource "aws_s3_object" "hex7" {
  bucket             = aws_s3_bucket.hex7.id
  key                = "${var.product}.zip"
  source             = data.archive_file.hex7.output_path
  etag               = filemd5(data.archive_file.hex7.output_path)
}


resource "aws_lambda_function" "hex7" {
  function_name      = var.product
  s3_bucket          = aws_s3_bucket.hex7.id
  s3_key             = aws_s3_object.hex7.key
  runtime            = var.lambda_runtime
  handler            = "${var.product}.handler"
  source_code_hash   = data.archive_file.hex7.output_base64sha256
  role               = aws_iam_role.hex7.arn
}


resource "aws_cloudwatch_log_group" "hex7_lambda" {
  name               = "/aws/lambda/${aws_lambda_function.hex7.function_name}"
  retention_in_days  = 30
}


resource "aws_iam_role" "hex7" {
  name               = "${var.product}_lambda"
  assume_role_policy = jsonencode({
    Version     = "2012-10-17"
    Statement   = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Sid       = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}


resource "aws_iam_role_policy_attachment" "hex7" {
  role               = aws_iam_role.hex7.name
  policy_arn         = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
