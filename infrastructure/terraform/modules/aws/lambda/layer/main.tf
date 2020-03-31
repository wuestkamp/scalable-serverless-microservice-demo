resource "aws_lambda_layer_version" "lambda_layer" {
  filename   = var.filename
  layer_name = var.layer_name

  compatible_runtimes = ["python3.8"]
}
