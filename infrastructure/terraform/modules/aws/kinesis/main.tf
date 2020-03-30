resource "aws_kinesis_stream" "stream" {
  name             = "scalable-microservice"
  shard_count      = 1
  retention_period = 48

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]
}

//resource "aws_kinesis_firehose_delivery_stream" "extended_s3_stream" {
//  name        = "terraform-kinesis-firehose-extended-s3-test-stream"
//  destination = "extended_s3"
//
//  extended_s3_configuration {
//    role_arn   = aws_iam_role.firehose_role.arn
//    bucket_arn = aws_s3_bucket.bucket.arn
//
////    processing_configuration {
////      enabled = "true"
////
////      processors {
////        type = "Lambda"
////
////        parameters {
////          parameter_name  = "LambdaArn"
//////          parameter_value = "${aws_lambda_function.lambda_processor.arn}:$LATEST"
////          parameter_value = var.lambda_processor_arn
////        }
////      }
////    }
//  }
//}
//
//resource "aws_s3_bucket" "bucket" {
//  bucket = "wuestkamp-scalable-microservice-kinesis-bucket"
//  acl    = "private"
//}
//
//resource "aws_iam_role" "firehose_role" {
//  name = "firehose_test_role"
//
//  assume_role_policy = <<EOF
//{
//  "Version": "2012-10-17",
//  "Statement": [
//    {
//      "Action": "sts:AssumeRole",
//      "Principal": {
//        "Service": "firehose.amazonaws.com"
//      },
//      "Effect": "Allow",
//      "Sid": ""
//    }
//  ]
//}
//EOF
//}
