terraform {
  backend "s3" {
    bucket = "my-banana-bucket"
    key    = "banana-state-staging"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 0.15.0"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}