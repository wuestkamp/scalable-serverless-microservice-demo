module "archiver" {
  source = "../../../modules/archiver"
  source_dir = "../../functions/user_create"
  output_path = "../../tmp/build/user_create.zip"
}

module "s3-object" {
  source  = "../../../modules/aws/s3/object"
  bucket_name = var.bucket_name
  object_key = "functions/user_create.zip"
  local_file_path = module.archiver.output_path
}

module "lambda" {
  source  = "../../../modules/aws/lambda/function"
  s3_bucket = var.bucket_name
  s3_key = module.s3-object.object_key
  s3_object_version = module.s3-object.version_id
  function_name = "user_create"
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
