resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda_${var.function_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    },
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {"Service": "kinesis.amazonaws.com"}
    }
  ]
}
EOF

}

resource "aws_iam_policy" "policy" {
  name        = "kinesis_policy_${var.function_name}"
  description = "A test policy"

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
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_lambda_function" "lambda" {
  s3_bucket     = var.s3_bucket
  s3_key        = var.s3_key
  function_name = var.function_name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = var.handler

  runtime = "python3.8"
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.region}:${var.account_id}:*/*/*/*"
}

//resource "aws_lambda_event_source_mapping" "mapping" {
//  event_source_arn  = var.event_source_arn
//  function_name     = aws_lambda_function.lambda.arn
//  starting_position = "LATEST"
//}
