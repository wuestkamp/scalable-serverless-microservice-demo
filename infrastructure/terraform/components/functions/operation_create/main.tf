module "archiver-operation-create" {
  source = "../../../modules/archiver"
  source_dir = "../../functions/operation_create"
  output_path = "../../tmp/build/operation_create.zip"
}

module "s3-operation-create-object" {
  source  = "../../../modules/aws/s3/object"
  bucket_name = var.bucket_name
  object_key = "functions/operation_create.zip"
  local_file_path = module.archiver-operation-create.output_path
}

module "lambda" {
  source  = "../../../modules/aws/lambda"
  s3_bucket = var.bucket_name
  s3_key = module.s3-operation-create-object.object_key
  function_name = "operation_create"
  handler = "main.lambda_handler"
  log_policy_arn = var.log_policy_arn
}

resource "aws_iam_policy" "policy" {
  name = "kinesis_policy_operation_create"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
          "kinesis:GetRecords",
          "kinesis:GetShardIterator",
          "kinesis:CreateStream",
          "kinesis:DeleteStream",
          "kinesis:DescribeStream",
          "kinesis:ListStreams",
          "kinesis:PutRecord",
          "kinesis:PutRecords"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = module.lambda.role_name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.execute-api-region}:${var.execute-api-account_id}:*/*/*/*"
}
