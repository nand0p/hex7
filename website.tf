resource "aws_s3_bucket" "hex7"{
  bucket        = var.bucket
  force_destroy = true
  tags          = var.tags
}

resource "aws_s3_bucket_public_access_block" "hex7" {
  bucket                  = aws_s3_bucket.hex7.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_acl" "hex7" {
  depends_on = [
    #aws_s3_bucket_ownership_controls.hex7,
    aws_s3_bucket_public_access_block.hex7
  ]
  bucket = aws_s3_bucket.hex7.id
  acl    = "public-read"
}


resource "aws_s3_bucket_website_configuration" "hex7" {
  bucket = aws_s3_bucket.hex7.id
  index_document { suffix = "index.html" }
}


resource "aws_s3_bucket_policy" "hex7" {
  bucket = aws_s3_bucket.hex7.id
  policy = data.aws_iam_policy_document.hex7.json
}


data "aws_iam_policy_document" "hex7" {
  statement {
    sid    = "AllowPublicRead"
    effect = "Allow"
    resources = [
      "arn:aws:s3:::${var.bucket}",
      "arn:aws:s3:::${var.bucket}/*",
    ]
    actions = ["S3:Get*", "S3:List*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "hex7" {
  bucket = aws_s3_bucket.hex7.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "null_resource" "hex7" {
  triggers = {
    file_changed = md5("index.html")
  }

  provisioner "local-exec" {
    command = "python3 app.py"
  }
}

resource "aws_s3_bucket_versioning" "hex7" {
  bucket = aws_s3_bucket.hex7.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "hex7_index" {
  depends_on       = [ null_resource.hex7,
                       aws_s3_bucket_versioning.hex7 ]
  bucket           = aws_s3_bucket.hex7.id
  key              = "index.html"
  source           = "index.html"
  acl              = "public-read"
  content_type     = "text/html"
  content_language = "en-US"
  etag             = filemd5("index.html")
  tags             = var.tags
}
resource "aws_s3_object" "hex7_favicon" {
  bucket           = aws_s3_bucket.hex7.id
  key              = "favicon.ico"
  source           = "static/favicon.ico"
  source_hash      = filemd5("static/favicon.ico")
  acl              = "public-read"
  tags             = var.tags
}
resource "aws_s3_object" "hex7_robots" {
  bucket           = aws_s3_bucket.hex7.id
  key              = "robots.txt"
  source           = "static/robots.txt"
  source_hash      = filemd5("static/robots.txt")
  acl              = "public-read"
  tags             = var.tags
}
