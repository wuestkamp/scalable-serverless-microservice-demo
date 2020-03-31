import json
import base64
import boto3
from datetime import datetime
import uuid as uuid_lib


def lambda_handler(event, context):
    for e in event['Records']:
        print(e['kinesis']['data'])
        data = json.loads(base64.b64decode(e['kinesis']['data']))
        print(data)
        user_create(data)


def user_create(msg):
    print(f'creating user for msg:{msg}')

    user = msg['data']
    user['createdAt'] = str(datetime.now())
    user['uuid'] = str(uuid_lib.uuid4())
    user['approved'] = 'pending'

    # result = mongodb_collection.insert_one(user.copy())
    # print(f'DynamoDB insert: {result.inserted_id}')

    msg['data'] = user
    send_message('user-approve', msg)
    # kafka.create_message(topic_user_approve, msg)
    # logging.info(f'send user approval for msg:{msg}')


def send_message(operation_name, data):
    client = boto3.client('kinesis')
    return client.put_record(
        StreamName='scalable-microservice-'+operation_name,
        Data=json.dumps(msg),
        PartitionKey='1'
    )
