terraform {
  backend "s3" {
    bucket = "siluryan-ci-cd-intro"
    key    = "state-staging"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.48"
    }

    random = {
      source = "hashicorp/random"
      version = "3.1.0"
    }
  }

  required_version = ">= 0.15.0"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

variable "base_ami_id" {
  description = "Base AMI ID"
  type        = string
}

resource "random_id" "server" {
  keepers = {
    # Generate a new id each time we switch to a new AMI id
    ami_id = "${var.base_ami_id}"
  }

  byte_length = 8
}

# This is the main staging environment. We will deploy to this the changes
# to the main branch before deploying to the production environment.
resource "aws_instance" "staging_cicd_demo" {
  # Read the AMI id "through" the random_id resource to ensure that
  # both will change together.
  ami                    = random_id.server.keepers.ami_id
  instance_type          = "t2.micro"

  tags = {
    "Name" = "staging_cicd_demo-${random_id.server.hex}"
  }
}

output "staging_dns" {
  value = aws_instance.staging_cicd_demo.public_dns
}
