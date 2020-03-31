import json
import base64
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('user_service')


def lambda_handler(event, context):
    for e in event['Records']:
        print(e['kinesis']['data'])
        data = json.loads(base64.b64decode(e['kinesis']['data']))
        print(data)
        user_create_response(data)


def user_create_response(msg):
    print(f'approving user for msg:{msg}')

    user = msg['data']

    user_dynamodb = user.copy()
    table.put_item(Item=user_dynamodb)
    print(f'MongoDB user updated')

    msg['data'] = user

    if user['approved'] == 'true':
        msg['response']['state'] = 'completed'
    elif user['approved'] == 'false':
        msg['response']['state'] = 'failed'
        msg['response']['error'] = 'approval failed'

    send_message('user-create-response', msg)
    print(f'updated user for msg:{msg}')


def send_message(operation_name, data):
    client = boto3.client('kinesis')
    return client.put_record(
        StreamName='scalable-microservice-'+operation_name,
        Data=json.dumps(data),
        PartitionKey='1'
    )
