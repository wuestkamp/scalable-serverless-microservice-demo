output "object_key" {
  value = aws_s3_bucket_object.object.key
}

output "version_id" {
  value = aws_s3_bucket_object.object.version_id
}
