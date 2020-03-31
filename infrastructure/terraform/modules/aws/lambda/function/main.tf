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
    }
  ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = var.log_policy_arn
}

resource "aws_iam_role_policy_attachment" "AWSXrayFullAccess" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayFullAccess"
}

resource "aws_lambda_function" "lambda" {
  s3_bucket     = var.s3_bucket
  s3_key        = var.s3_key
  function_name = var.function_name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = var.handler

  runtime = "python3.8"
  timeout = var.timeout

  tracing_config {
    mode = "Active"
  }

  layers = var.layers
}
