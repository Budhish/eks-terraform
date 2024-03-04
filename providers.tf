
provider "aws" {
  profile = "terraform"
  region = "us-east-2"
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.23.1"
    }
  }
}