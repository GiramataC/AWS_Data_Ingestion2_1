terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.11"
    }
  }

  # bucket/dynamodb_table are account-specific and supplied via -backend-config
  # (see backend.hcl.example) so they never appear in this committed file.
  backend "s3" {
    key     = "datasync-lab-2.2/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
}
