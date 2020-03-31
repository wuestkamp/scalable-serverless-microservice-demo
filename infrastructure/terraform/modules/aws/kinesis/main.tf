resource "aws_kinesis_stream" "stream" {
  name             = var.name
  shard_count      = 1
  retention_period = 48

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]
}
