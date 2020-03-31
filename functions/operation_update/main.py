import json
import base64
import boto3
from aws_xray_sdk.core import patch
patch(['boto3'])


dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('operation_service')


def lambda_handler(event, context):
    for e in event['Records']:
        print(e['kinesis']['data'])
        data = json.loads(base64.b64decode(e['kinesis']['data']))
        print(data)
        operation_update(data)


def operation_update(msg):
    if msg['response']['state'] == 'completed':
        msg['state'] = 'completed'
    else:
        msg['state'] = 'failed'
        msg['error'] = msg['response']['error']
    msg_dynamodb = msg.copy()
    table.put_item(Item=msg_dynamodb)
    print(f'DynamoDB update done')
