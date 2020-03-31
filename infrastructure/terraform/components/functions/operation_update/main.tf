module "archiver-operation-update" {
  source = "../../../modules/archiver"
  source_dir = "../../functions/operation_update"
  output_path = "../../tmp/build/operation_update.zip"
}

module "s3-operation-update-object" {
  source  = "../../../modules/aws/s3/object"
  bucket_name = var.bucket_name
  object_key = "functions/operation_update.zip"
  local_file_path = module.archiver-operation-update.output_path
}

module "lambda" {
  source  = "../../../modules/aws/lambda/function"
  s3_bucket = var.bucket_name
  s3_key = module.s3-operation-update-object.object_key
  function_name = "operation_update"
  handler = "main.lambda_handler"
  log_policy_arn = var.log_policy_arn
  layers = var.layers
}

resource "aws_lambda_event_source_mapping" "mapping" {
  event_source_arn  = var.event_source_kinesis_arn
  function_name     = module.lambda.function_name
  starting_position = "LATEST"
}

resource "aws_iam_role_policy_attachment" "AmazonDynamoDBFullAccess" {
  role       = module.lambda.role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "AmazonKinesisFullAccess" {
  role       = module.lambda.role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonKinesisFullAccess"
}
