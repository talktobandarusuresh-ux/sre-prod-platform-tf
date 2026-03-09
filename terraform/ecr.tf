resource "aws_ecr_repository" "app_repo" {

  name = "sre-demo-app"

  image_tag_mutability = "MUTABLE"
}