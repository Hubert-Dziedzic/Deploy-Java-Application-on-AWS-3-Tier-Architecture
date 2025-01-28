terraform {
  backend "s3" {
    bucket = "bucket-name"
    key = "tfstate.tf"
    region = "value"
    encrypt = true
    dynamodb_table = "terraform-lock-table"
  }
}