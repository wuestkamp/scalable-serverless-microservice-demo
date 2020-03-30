provider "aws" {
  version = "~> 2.5"
  region  = "eu-central-1"
}

terraform {
  backend "s3" {
    // aws s3api create-bucket --bucket wuestkamp-terraform-bucket --region eu-central-1 --create-bucket-configuration LocationConstraint=eu-central-1
    bucket = "wuestkamp-terraform-bucket"
    key    = "terraform/scalable-microservice-demo"
    region  = "eu-central-1"
  }
}

module "dynamodb-user-service" {
  source  = "./modules/aws/dynamodb"
  table_name = "user_service"
}

module "dynamodb-operation-service" {
  source  = "./modules/aws/dynamodb"
  table_name = "operation_service"
}


module "s3-user-create" {
  source  = "./modules/aws/s3/bucket"
  bucket_name = "wuestkamp-scalable-microservice-demo-user-create"
}

module "s3-user-create-object" {
  source  = "./modules/aws/s3/object"
  bucket_name = "wuestkamp-scalable-microservice-demo-user-create"
  object_name = "main.py"
  local_file_path = "../../functions/user_create/main.py"
}


module "lambda-user-create" {
  source  = "./modules/aws/lambda"
}






//module "elasticsearch" {
//  source  = "./modules/aws/elasticsearch"
//}

//module "iam" {
//  source  = "./modules/aws/iam"
//}
//
//module "vpc" {
//  source  = "./modules/aws/vpc"
//}
//
//module "eks" {
//  source  = "./modules/aws/eks"
//}
//
//module "ecr" {
//  source  = "./modules/aws/ecr"
//}
