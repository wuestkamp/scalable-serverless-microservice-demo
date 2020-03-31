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
module "api-gateway" {
  source  = "./modules/aws/api_gateway/rest_api"
  api_name = "scalable-microservice"
}

module "api-gateway-operation-create" {
  source  = "./modules/aws/api_gateway/resource"
  api_id = module.api-gateway.id
  api_root_resource_id = module.api-gateway.root_resource_id
  lambda_invoke_arn = module.function-operation-create.invoke_arn
  path_part = "operation-create"
  http_method = "POST"
}

module "api-gateway-operation-get" {
  source  = "./modules/aws/api_gateway/resource"
  api_id = module.api-gateway.id
  api_root_resource_id = module.api-gateway.root_resource_id
  lambda_invoke_arn = module.function-operation-get.invoke_arn
  path_part = "operation-get"
  http_method = "POST"
}


// ### kinesis ###
module "kinesis-user-create" {
  source  = "./modules/aws/kinesis"
  name = "scalable-microservice-user-create"
}

module "kinesis-user-create-response" {
  source  = "./modules/aws/kinesis"
  name = "scalable-microservice-user-create-response"
}

module "kinesis-user-approve" {
  source  = "./modules/aws/kinesis"
  name = "scalable-microservice-user-approve"
}

module "kinesis-user-approve-response" {
  source  = "./modules/aws/kinesis"
  name = "scalable-microservice-approve-response"
}


// ### functions ###
module "function-operation-create" {
  source = "./components/functions/operation_create"
  bucket_name = module.s3-functions.bucket_name
  execute-api-region = "eu-central-1"
  execute-api-account_id = "110266633125"
  log_policy_arn = aws_iam_policy.lambda_logging.arn
}

module "function-operation-get" {
  source = "./components/functions/operation_get"
  bucket_name = module.s3-functions.bucket_name
  execute-api-region = "eu-central-1"
  execute-api-account_id = "110266633125"
  log_policy_arn = aws_iam_policy.lambda_logging.arn
}

module "function-user-create" {
  source = "./components/functions/user_create"
  bucket_name = module.s3-functions.bucket_name
  event_source_kinesis_arn = module.kinesis-user-create.arn
  log_policy_arn = aws_iam_policy.lambda_logging.arn
}
