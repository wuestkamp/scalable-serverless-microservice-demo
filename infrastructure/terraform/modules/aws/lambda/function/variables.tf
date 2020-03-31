variable "s3_bucket" {}

variable "s3_key" {}

variable "s3_object_version" {}

variable "function_name" {}

variable "handler" {}

variable "log_policy_arn" {}

variable "timeout" {
  default = 3
}

variable "layers" {
  type = "list"
  default = []
}
