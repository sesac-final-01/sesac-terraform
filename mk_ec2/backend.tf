# /vpc/backend.tf
terraform {
  backend "s3" {
    bucket = "terraform-backend-sesacs"
    key    = "ec2/terraform.tfstate"
    region = "us-east-1"
    #profile = "histdc-dev-terraform"
  }
}
