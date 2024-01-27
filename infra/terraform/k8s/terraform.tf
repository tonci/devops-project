terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.33.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.5"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.3.3"
    }
  }

  backend "s3" {
    bucket         = "tonci-course-tf-state"
    dynamodb_table = "tf_locks"
    key            = "my-terraform-project"
    region         = "eu-west-1"
  }

  required_version = ">= 1.7.0"
}

