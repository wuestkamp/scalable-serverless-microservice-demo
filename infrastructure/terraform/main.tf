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


// ### api-gateway ###
module "api-gateway-operation-create" {
  source  = "./modules/aws/api_gateway"
  api_name = "scalable-microservice-demo"
  lambda_invoke_arn = module.function-operation-create.invoke_arn
  path_part = "operation-create"
  http_method = "POST"
}


// ### kinesis ###
module "kinesis" {
  source  = "./modules/aws/kinesis"
}


// ### functions ###
module "function-operation-create" {
  source = "./components/functions/operation_create"
  bucket_name = module.s3-functions.bucket_name
  execute-api-region = "eu-central-1"
  execute-api-account_id = "110266633125"
}

module "function-user-create" {
  source = "./components/functions/user_create"
  bucket_name = module.s3-functions.bucket_name
  event_source_kinesis_arn = module.kinesis.arn
}
