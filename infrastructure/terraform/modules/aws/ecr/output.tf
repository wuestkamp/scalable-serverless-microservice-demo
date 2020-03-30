output "producer_service_repository_url" {
  value = "${aws_ecr_repository.demo-producer-service.repository_url}"
}

output "roducer_service_arn" {
  value = "${aws_ecr_repository.demo-producer-service.arn}"
}
