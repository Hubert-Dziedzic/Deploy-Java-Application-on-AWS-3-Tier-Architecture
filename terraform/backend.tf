terraform {
  backend "s3" {
    bucket = "terraform-state-612781"
    key = "global/s3/terraform.tfstate"
    region = "eu-central-1"
    dynamodb_table = "terraform-state-locking"
    encrypt = true
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "terraform_state" {
    bucket = "terraform-state-612781"

    lifecycle {
      prevent_destroy = true
    }

    versioning {
      enabled = true
    }

    server_side_encryption_configuration {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = "AES256"
        }
      }
    }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name = "terraform-state-locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

