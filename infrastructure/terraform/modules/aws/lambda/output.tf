output "invoke_arn" {
  value = aws_lambda_function.lambda.invoke_arn
}

output "role_name" {
  value = aws_iam_role.iam_for_lambda.name
}

output "function_name" {
  value = aws_lambda_function.lambda.function_name
}
