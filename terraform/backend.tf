# terraform {

#   backend "s3" {

#     bucket = "sre-terraform-state-bucket"

#     key = "sre-platform/terraform.tfstate"

#     region = "us-east-1"

#     dynamodb_table = "terraform-lock"

#     encrypt = true
#   }
# }

terraform {
  backend "s3" {
    bucket  = "sre-terraform-state-bucket"
    key     = "sre-platform/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}