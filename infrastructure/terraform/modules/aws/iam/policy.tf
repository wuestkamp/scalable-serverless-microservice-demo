resource "aws_iam_policy" "policy" {
  name        = "ddb-elasticsearch-bridge"
  path        = "/"
  description = "Elastic Dynamo Bridge"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:DescribeStream",
        "dynamodb:GetRecords",
        "dynamodb:GetShardIterator",
        "dynamodb:ListStreams",
        "es:ESHttpPost"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": [
            "lambda:GetAccountSettings",
            "lambda:ListFunctions",
            "lambda:ListTags",
            "lambda:GetEventSourceMapping",
            "lambda:ListEventSourceMappings"
        ],
        "Resource": "*"
    }
  ]
}
EOF
}
