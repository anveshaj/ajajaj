provider "aws" {
    region = "${var.hbiregion}"
}

terraform {
  backend "s3" {
    bucket = "ajajaj123456"
    key    = "/root/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "dynamodb-terraform"
  }
}
