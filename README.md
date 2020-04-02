# Scalable Serverless Microservice Demo AWS Kinesis Lambda

Medium article: https://medium.com/@wuestkamp/scalable-serverless-microservice-demo-aws-lambda-kinesis-terraform-cbe6036bf5ac?sk=074614683a6641cab9b6067929bdc660


## setup
```
cp .env .env.local
# fill in credentials in .env.local

./run/install.sh
```


## usage
Terraform will also output commands to query and use the api.

```
curl -X POST \
    -H 'Content-Type: application/json' \
    -d '{"name": "hans"}' \
    "https://XXX.execute-api.eu-central-1.amazonaws.com/prod/operation-create"

curl -X POST \
    -H 'Content-Type: application/json' \
    -d '{"uuid": "XXX"}' \
    "https://XXX.execute-api.eu-central-1.amazonaws.com/prod/operation-get"
```


## destroy
```
./run/destroy.sh
```
