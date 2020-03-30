output "table_name" {
  value       = join("", aws_dynamodb_table.basic-dynamodb-table.*.name)
  description = "DynamoDB table name"
}

output "table_id" {
  value       = join("", aws_dynamodb_table.basic-dynamodb-table.*.id)
  description = "DynamoDB table ID"
}

output "table_arn" {
  value       = join("", aws_dynamodb_table.basic-dynamodb-table.*.arn)
  description = "DynamoDB table ARN"
}

output "stream_arn" {
  value       = join("", aws_dynamodb_table.basic-dynamodb-table.*.stream_arn)
  description = "DynamoDB stream ARN"
}

output "stream_label" {
  value       = join("", aws_dynamodb_table.basic-dynamodb-table.*.stream_label)
  description = "DynamoDB stream label"
}
