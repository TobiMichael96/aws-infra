terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Terraform   = true
      Environment = var.environment
      Prefix      = var.resource_prefix
    }
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "certificate"
  default_tags {
    tags = {
      Terraform   = true
      Environment = var.environment
      Prefix      = var.resource_prefix
    }
  }
}

terraform {
  backend "s3" {
  }
}