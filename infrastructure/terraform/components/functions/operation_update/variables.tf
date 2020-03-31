variable "bucket_name" {}

variable "log_policy_arn" {}

variable "event_source_kinesis_arn" {}

variable "layers" {
  type = "list"
  default = []
}
