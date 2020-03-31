module "dynamodb-user-service" {
  source = "./modules/aws/dynamodb"
  table_name = "user_service"
}

module "dynamodb-operation-service" {
  source = "./modules/aws/dynamodb"
  table_name = "operation_service"
}
