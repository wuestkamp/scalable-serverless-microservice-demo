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
  wait_for = module.api-gateway-operation-create.invoke_url
}
