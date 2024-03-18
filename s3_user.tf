resource "aws_iam_user" "hex7" {
  name        = "hex7-deploy"
  path        = "/"
  tags        = var.tags
}

resource "aws_iam_access_key" "hex7" {
  user        = aws_iam_user.hex7.name
}

data "aws_iam_policy_document" "hex7_deploy" {
  statement {
    effect    = "Allow"
    actions   = ["*"]
    resources = ["arn:aws:s3:::hex7.com",
                 "arn:aws:s3:::hex7.com/*" ]
  }
}

resource "aws_iam_user_policy" "hex7" {
  name        = "hex7-deploy"
  user        = aws_iam_user.hex7.name
  policy      = data.aws_iam_policy_document.hex7_deploy.json
}

output "iam_user" {
  value       = aws_iam_access_key.hex7.id
}

output "iam_secret" {
  value       = nonsensitive(aws_iam_access_key.hex7.secret)
  sensitive   = true
}
