module "lambda-layer-aws-xray-sdk" {
  source = "./modules/aws/lambda/layer"
  layer_name = "aws-xray-sdk"
  filename = "../../functions/layers/aws-xray-sdk/python.zip"
}

module "function-operation-create" {
  source = "./components/functions/operation_create"
  bucket_name = module.s3-functions.bucket_name
  execute-api-region = "eu-central-1"
  execute-api-account_id = "110266633125"
  log_policy_arn = aws_iam_policy.lambda_logging.arn
  layers = [module.lambda-layer-aws-xray-sdk.arn]
}

module "function-operation-get" {
  source = "./components/functions/operation_get"
  bucket_name = module.s3-functions.bucket_name
  execute-api-region = "eu-central-1"
  execute-api-account_id = "110266633125"
  log_policy_arn = aws_iam_policy.lambda_logging.arn
  layers = [module.lambda-layer-aws-xray-sdk.arn]
}

module "function-operation-update" {
  source = "./components/functions/operation_update"
  bucket_name = module.s3-functions.bucket_name
  event_source_kinesis_arn = module.kinesis-user-create-response.arn
  log_policy_arn = aws_iam_policy.lambda_logging.arn
  layers = [module.lambda-layer-aws-xray-sdk.arn]
}

module "function-user-create" {
  source = "./components/functions/user_create"
  bucket_name = module.s3-functions.bucket_name
  event_source_kinesis_arn = module.kinesis-user-create.arn
  log_policy_arn = aws_iam_policy.lambda_logging.arn
  layers = [module.lambda-layer-aws-xray-sdk.arn]
}

module "function-user-create-response" {
  source = "./components/functions/user_create_response"
  bucket_name = module.s3-functions.bucket_name
  event_source_kinesis_arn = module.kinesis-user-approve-response.arn
  log_policy_arn = aws_iam_policy.lambda_logging.arn
  layers = [module.lambda-layer-aws-xray-sdk.arn]
}

module "function-user-approve" {
  source = "./components/functions/user_approve"
  bucket_name = module.s3-functions.bucket_name
  event_source_kinesis_arn = module.kinesis-user-approve.arn
  log_policy_arn = aws_iam_policy.lambda_logging.arn
  layers = [module.lambda-layer-aws-xray-sdk.arn]
}
