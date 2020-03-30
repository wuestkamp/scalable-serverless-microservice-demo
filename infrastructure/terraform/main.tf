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
