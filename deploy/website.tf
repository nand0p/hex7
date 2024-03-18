resource "null_resource" "hex7" {
  triggers = {
    file_changed = md5("index.html")
  }

  provisioner "local-exec" {
    command = "python3 ../app.py"
  }
}

resource "aws_s3_object" "hex7_index" {
  depends_on       = [ null_resource.hex7 ]
  bucket           = var.bucket
  key              = "index.html"
  source           = "index.html"
  acl              = "public-read"
  content_type     = "text/html"
  content_language = "en-US"
  etag             = filemd5("index.html")
  tags             = var.tags
}
resource "aws_s3_object" "hex7_favicon" {
  bucket           = var.bucket
  key              = "favicon.ico"
  source           = "../static/favicon.ico"
  source_hash      = filemd5("../static/favicon.ico")
  acl              = "public-read"
  tags             = var.tags
}
resource "aws_s3_object" "hex7_robots" {
  bucket           = var.bucket
  key              = "robots.txt"
  source           = "../static/robots.txt"
  source_hash      = filemd5("../static/robots.txt")
  acl              = "public-read"
  tags             = var.tags
}
