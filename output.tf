output "hex7_site_version" {
  value = aws_s3_object.hex7_index.version_id
}

output "hashicorp_s3_domain" {
  value = aws_s3_bucket.hex7.bucket_domain_name
}

output "hex7_s3_regional_domain" {
  value = aws_s3_bucket.hex7.bucket_regional_domain_name
}


output "hashicorp_s3_acl" {
  value = aws_s3_object.hex7_index.acl
}
output "hashicorp_s3_etag" { 
  value = aws_s3_object.hex7_index.etag
}
