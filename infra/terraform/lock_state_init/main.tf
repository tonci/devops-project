terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.33"
    }
  }

  required_version = ">= 1.7.0"
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "s3_tf_state" {
  bucket = "tonci-course-tf-state"
  tags = {
    purpose = "course"
  }
}

resource "aws_s3_bucket_versioning" "tf_versioned" {
  bucket = aws_s3_bucket.s3_tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "dynamodb_tf_state" {
  name           = "tf_locks"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    purpose = "course"
  }
}
