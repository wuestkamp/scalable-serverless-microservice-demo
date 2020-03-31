module "kinesis-user-create" {
  source  = "./modules/aws/kinesis"
  name = "scalable-microservice-user-create"
}

module "kinesis-user-create-response" {
  source  = "./modules/aws/kinesis"
  name = "scalable-microservice-user-create-response"
}

module "kinesis-user-approve" {
  source  = "./modules/aws/kinesis"
  name = "scalable-microservice-user-approve"
}

module "kinesis-user-approve-response" {
  source  = "./modules/aws/kinesis"
  name = "scalable-microservice-user-approve-response"
}
