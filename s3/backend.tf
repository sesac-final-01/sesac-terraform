## s3/backend.tf
terraform {
  backend "s3" {
    bucket = "terraform-backend-sesacs"
    key    = "s3/terraform.tfstate"
    # region = "ap-northeast-2"
    region = "us-east-1"
    #profile = "histdc-dev-terraform"
  }
}
#
