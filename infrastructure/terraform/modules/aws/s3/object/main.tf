resource "aws_s3_bucket_object" "object" {
  bucket = var.bucket_name
  key    = var.object_key
  source = var.local_file_path
  etag = "${filemd5(var.local_file_path)}"
}
