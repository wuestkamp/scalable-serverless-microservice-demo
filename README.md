# Scalable Serverless Microservice Demo AWS Kinesis Lambda

Medium article: TODO


## setup
```
cp .env .env.local
# fill in credentials on .env.local

./run/install.sh
```


## usage
Terraform will output commands to query and use the api.

```
curl -X POST -H 'Content-Type: application/json' -d '{"name": "hans"}' "https://XXX.execute-api.eu-central-1.amazonaws.com/prod/operation_create"
```


## destroy
```
./run/destroy.sh
```
