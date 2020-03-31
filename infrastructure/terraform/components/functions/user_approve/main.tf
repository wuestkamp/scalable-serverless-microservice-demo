module "archiver" {
  source = "../../../modules/archiver"
  source_dir = "../../functions/user_approve"
  output_path = "../../tmp/build/user_approve.zip"
}

module "s3-object" {
  source  = "../../../modules/aws/s3/object"
  bucket_name = var.bucket_name
  object_key = "functions/user_approve.zip"
  local_file_path = module.archiver.output_path
}

module "lambda" {
  source  = "../../../modules/aws/lambda/function"
  s3_bucket = var.bucket_name
  s3_key = module.s3-object.object_key
  s3_object_version = module.s3-object.version_id
  function_name = "user_approve"
  handler = "main.lambda_handler"
  log_policy_arn = var.log_policy_arn
  timeout = 15
  layers = var.layers
}

resource "aws_lambda_event_source_mapping" "mapping" {
  event_source_arn  = var.event_source_kinesis_arn
  function_name     = module.lambda.function_name
  starting_position = "LATEST"
}

resource "aws_iam_role_policy_attachment" "AmazonKinesisFullAccess" {
  role       = module.lambda.role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonKinesisFullAccess"
}
