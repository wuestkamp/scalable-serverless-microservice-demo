import json
import boto3
import uuid as uuid_lib
from aws_xray_sdk.core import patch
patch(['boto3'])


def lambda_handler(event, context):
    operation_name = 'user-create'
    data = json.loads(event['body'])
    print(data)
    uuid = uuid_lib.uuid4()
    msg = {
        'uuid': f'{uuid}',
        'type': operation_name,
        'state': 'pending',
        'data': data,
        'response': {
            'state': 'pending'
        }
    }

    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('operation_service')
    table.put_item(
        Item=msg
    )

    client = boto3.client('kinesis')
    response = client.put_record(
        StreamName='scalable-microservice-' + operation_name,
        Data=json.dumps(msg),
        PartitionKey='1'
    )

    return {
        'statusCode': 200,
        'body': json.dumps(msg)
    }

