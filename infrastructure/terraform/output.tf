output "dynamodb-user-service-table-arn" {
  description = "Table Arn"
  value       = "${module.dynamodb-user-service.table_arn}"
}

output "dynamodb-user-service-table-name" {
  description = "Table name"
  value       = "${module.dynamodb-user-service.table_name}"
}

output "dynamodb-user-service-stream-arm" {
  value       = "${module.dynamodb-user-service.stream_arn}"
}

output "dynamodb-user-service-stream-label" {
  value       = "${module.dynamodb-user-service.stream_label}"
}


output "dynamodb-operation-service-table-arn" {
  description = "Table Arn"
  value       = "${module.dynamodb-operation-service.table_arn}"
}

output "dynamodb-operation-service-table-name" {
  description = "Table name"
  value       = "${module.dynamodb-operation-service.table_name}"
}

output "dynamodb-operation-service-stream-arm" {
  value       = "${module.dynamodb-operation-service.stream_arn}"
}

output "dynamodb-operation-service-stream-label" {
  value       = "${module.dynamodb-operation-service.stream_label}"
}


//output "es_endpoint" {
//  value = "${module.elasticsearch.es_endpoint}"
//}
//
//output "es_kibana_endpoint" {
//  value = "${module.elasticsearch.es_kibana_endpoint}"
//}
//
//output "eks_kubeconfig" {
//  value = "${module.eks.kubeconfig}"
//}
//
//output "eks_config_map_aws_auth" {
//  value = "${module.eks.config_map_aws_auth}"
//}
//
//output "ecr_roducer_service_repository_url" {
//  value = "${module.ecr.producer_service_repository_url}"
//}
//
//output "ecr_roducer_service_arn" {
//  value = "${module.ecr.roducer_service_arn}"
//}
