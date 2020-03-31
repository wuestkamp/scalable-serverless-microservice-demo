module "archiver" {
  source = "../../../modules/archiver"
  source_dir = "../../functions/operation_create"
  output_path = "../../tmp/build/operation_create.zip"
}

module "s3-object" {
  source  = "../../../modules/aws/s3/object"
  bucket_name = var.bucket_name
  object_key = "functions/operation_create.zip"
  local_file_path = module.archiver.output_path
}

module "lambda" {
  source  = "../../../modules/aws/lambda/function"
  s3_bucket = var.bucket_name
  s3_key = module.s3-object.object_key
  s3_object_version = module.s3-object.version_id
  function_name = "operation_create"
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
