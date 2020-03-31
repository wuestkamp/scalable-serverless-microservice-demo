import json
import boto3
from aws_xray_sdk.core import patch
patch(['boto3'])


def lambda_handler(event, context):
    data = json.loads(event['body'])
    print(data)
    uuid = data['uuid']

    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('operation_service')
    result = table.get_item(
        Key={
            'uuid': uuid
        }
    )

    if 'Item' in result:
        return {
            'statusCode': 200,
            'body': json.dumps(result['Item'])
        }
    else:
        return {
            'statusCode': 404,
            'body': json.dumps({
                'error': 'not_found'
            })
        }
