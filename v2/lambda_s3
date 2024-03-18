resource "random_pet" "hex7" {
  prefix             = "${var.product}"
  length             = 2
}


resource "aws_s3_bucket" "hex7" {
  bucket             = random_pet.hex7.id
}


resource "aws_s3_bucket_ownership_controls" "hex7" {
  bucket             = aws_s3_bucket.hex7.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


resource "aws_s3_bucket_acl" "hex7" {
  depends_on         = [aws_s3_bucket_ownership_controls.hex7]
  bucket             = aws_s3_bucket.hex7.id
  acl                = "private"
}
