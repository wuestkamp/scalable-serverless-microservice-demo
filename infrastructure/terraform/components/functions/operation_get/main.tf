module "archiver-operation-get" {
  source = "../../../modules/archiver"
  source_dir = "../../functions/operation_get"
  output_path = "../../tmp/build/operation_get.zip"
}

module "s3-operation-get-object" {
  source  = "../../../modules/aws/s3/object"
  bucket_name = var.bucket_name
  object_key = "functions/operation_get.zip"
  local_file_path = module.archiver-operation-get.output_path
}

module "lambda" {
  source  = "../../../modules/aws/lambda/function"
  s3_bucket = var.bucket_name
  s3_key = module.s3-operation-get-object.object_key
  function_name = "operation_get"
  handler = "main.lambda_handler"
  log_policy_arn = var.log_policy_arn
  layers = var.layers
}

resource "aws_iam_role_policy_attachment" "AmazonDynamoDBFullAccess" {
  role       = module.lambda.role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "AmazonKinesisFullAccess" {
  role       = module.lambda.role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonKinesisFullAccess"
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # more: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.execute-api-region}:${var.execute-api-account_id}:*/*/*/*"
}
