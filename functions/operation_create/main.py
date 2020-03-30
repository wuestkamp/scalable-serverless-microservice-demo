import json
import boto3


def lambda_handler(event, context):
    client = boto3.client('kinesis')

    response = client.put_record(
        StreamName='scalable-microservice',
        Data=b'bytes',
        PartitionKey='1'
    )

    return {
        'statusCode': 200,
        'body': json.dumps('Hello from operation_createddd')
    }
