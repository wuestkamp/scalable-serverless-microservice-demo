import json
import base64
import boto3
import time
from aws_xray_sdk.core import patch
patch(['boto3'])


def lambda_handler(event, context):
    for e in event['Records']:
        print(e['kinesis']['data'])
        data = json.loads(base64.b64decode(e['kinesis']['data']))
        print(data)
        user_approve(data)


def user_approve(msg):
    print(f'approving user for msg:{msg}')

    time.sleep(5)

    user = msg['data']
    user['approved'] = 'true'

    msg['data'] = user

    send_message('user-approve-response', msg)
    print(f'send user approve-response for msg:{msg}')


def send_message(operation_name, data):
    client = boto3.client('kinesis')
    return client.put_record(
        StreamName='scalable-microservice-'+operation_name,
        Data=json.dumps(data),
        PartitionKey='1'
    )
