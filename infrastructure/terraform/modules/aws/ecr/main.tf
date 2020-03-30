resource "aws_ecr_repository" "demo-producer-service" {
  name                 = "demo/producer_service"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  timeouts {
    delete = "0"
  }
}
