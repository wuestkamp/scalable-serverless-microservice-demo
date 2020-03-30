resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

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

resource "aws_lambda_function" "lambda" {
  s3_bucket     = var.s3_bucket
  s3_key        = var.s3_key
  function_name = var.function_name
  role          = "${aws_iam_role.iam_for_lambda.arn}"
  handler       = var.handler

  runtime = "python3.8"
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
//  source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.resource.path}"
  source_arn = "arn:aws:execute-api:${var.region}:${var.account_id}:*/*/*/*"
}

//resource "aws_lambda_function" "lambda" {
//  filename      = "lambda.zip"
//  function_name = "mylambda"
//  role          = "${aws_iam_role.role.arn}"
//  handler       = "lambda.lambda_handler"
//  runtime       = "python2.7"
//
//  # The filebase64sha256() function is available in Terraform 0.11.12 and later
//  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
//  # source_code_hash = "${base64sha256(file("lambda.zip"))}"
//  source_code_hash = "${filebase64sha256("lambda.zip")}"
//}

//# IAM
//resource "aws_iam_role" "role" {
//  name = "myrole"
//
//  assume_role_policy = <<POLICY
//{
//  "Version": "2012-10-17",
//  "Statement": [
//    {
//      "Action": "sts:AssumeRole",
//      "Principal": {
//        "Service": "lambda.amazonaws.com"
//      },
//      "Effect": "Allow",
//      "Sid": ""
//    }
//  ]
//}
//POLICY
//}
