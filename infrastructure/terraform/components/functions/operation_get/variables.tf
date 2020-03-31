variable "bucket_name" {}

variable "execute-api-region" {}

variable "execute-api-account_id" {}

variable "log_policy_arn" {}

variable "layers" {
  type = "list"
  default = []
}
