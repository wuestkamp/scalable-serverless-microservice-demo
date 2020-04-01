# Scalable Serverless Microservice Demo AWS Kinesis Lambda

Medium article: TODO


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
