terraform {
  backend "s3" {
    bucket         = "siluryan-terraform-state"
    key            = "siluryan-state-staging"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock-dynamo"
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