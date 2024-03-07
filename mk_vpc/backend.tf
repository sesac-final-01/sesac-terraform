# /vpc/backend.tf
terraform {
  backend "s3" {
    bucket = "terraform-backend-sesacs"
    key    = "vpc/terraform.tfstate"
    region = "us-east-1"
    #profile = "histdc-dev-terraform"
  }
}
