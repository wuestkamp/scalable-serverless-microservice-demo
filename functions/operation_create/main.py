import json
import boto3
import uuid as uuid_lib


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

    client = boto3.client('kinesis')
    response = client.put_record(
        StreamName='scalable-microservice-'+operation_name,
        Data=json.dumps(msg),
        PartitionKey='1'
    )

    return {
        'statusCode': 200,
        'body': json.dumps('Hello from operation_create!')
    }
