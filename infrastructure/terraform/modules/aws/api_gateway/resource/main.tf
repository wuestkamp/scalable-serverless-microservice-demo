resource "aws_api_gateway_resource" "resource" {
  path_part   = var.path_part
  parent_id   = var.api_root_resource_id
  rest_api_id = var.api_id
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = var.api_id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = var.http_method
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = var.api_id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

resource "aws_api_gateway_deployment" "api" {
  depends_on  = [aws_api_gateway_integration.integration]
  rest_api_id = var.api_id
  stage_name  = "prod"
}
