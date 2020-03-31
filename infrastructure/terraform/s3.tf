module "s3-functions" {
  source = "./modules/aws/s3/bucket"
  bucket_name = "wuestkamp-scalable-microservice-demo-functions"
}
