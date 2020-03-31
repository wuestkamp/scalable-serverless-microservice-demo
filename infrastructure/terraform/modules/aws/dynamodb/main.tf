resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = var.table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "uuid"
  stream_enabled = true
  stream_view_type = "NEW_IMAGE"

  attribute {
    name = "uuid"
    type = "S"
  }
}
