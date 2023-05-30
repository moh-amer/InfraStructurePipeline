terraform {
  backend "s3" {
    bucket         = "terraform-config-iti"
    key            = "terraform.tfstate"
    dynamodb_table = "dynamodb_lock_terraform"
    region         = "us-east-1"
  }

}
