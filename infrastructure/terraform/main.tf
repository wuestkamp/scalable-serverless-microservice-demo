provider "aws" {
  version = "~> 2.5"
  region = "eu-central-1"
}

terraform {
  backend "s3" {
    // aws s3api create-bucket --bucket wuestkamp-terraform-bucket --region eu-central-1 --create-bucket-configuration LocationConstraint=eu-central-1
    bucket = "wuestkamp-terraform-bucket"
    key = "terraform/scalable-microservice-demo"
    region = "eu-central-1"
  }
}


// ### DynamoDB ###
module "dynamodb-user-service" {
  source = "./modules/aws/dynamodb"
  table_name = "user_service"
}

module "dynamodb-operation-service" {
  source = "./modules/aws/dynamodb"
  table_name = "operation_service"
}


// ### bucket for all functions ###
module "s3-functions" {
  source = "./modules/aws/s3/bucket"
  bucket_name = "wuestkamp-scalable-microservice-demo-functions"
}


// ### user-create ###
module "archiver-user-create" {
  source = "./modules/archiver"
  source_dir = "../../functions/user_create"
  output_path = "../../tmp/build/user_create.zip"
}

module "s3-user-create-object" {
  source  = "./modules/aws/s3/object"
  bucket_name = module.s3-functions.bucket_name
  object_key = "functions/user_create.zip"
  local_file_path = module.archiver-user-create.output_path
}

module "lambda-user-create" {
  source  = "./modules/aws/lambda"
  s3_bucket = module.s3-functions.bucket_name
  s3_key = module.s3-user-create-object.object_key
  function_name = "user_create"
  handler = "main.lambda_handler"
  region = "eu-central-1"
  account_id = "110266633125"
  event_source_arn = module.kinesis.arn
}


// ### operation-create ###
module "archiver-operation-create" {
  source = "./modules/archiver"
  source_dir = "../../functions/operation_create"
  output_path = "../../tmp/build/operation_create.zip"
}

module "s3-operation-create-object" {
  source  = "./modules/aws/s3/object"
  bucket_name = module.s3-functions.bucket_name
  object_key = "functions/operation_create.zip"
  local_file_path = module.archiver-operation-create.output_path
}

module "lambda-operation-create" {
  source  = "./modules/aws/lambda"
  s3_bucket = module.s3-functions.bucket_name
  s3_key = module.s3-operation-create-object.object_key
  function_name = "operation_create"
  handler = "main.lambda_handler"
  region = "eu-central-1"
  account_id = "110266633125"
  event_source_arn = module.kinesis.arn
}


// ### api-gateway ###
module "api-gateway-operation-create" {
  source  = "./modules/aws/api_gateway"
  api_name = "scalable-microservice-demo"
  lambda_invoke_arn = module.lambda-operation-create.invoke_arn
  path_part = "operation-create"
  http_method = "POST"
}


// ### kinesis ###
module "kinesis" {
  source  = "./modules/aws/kinesis"
}
