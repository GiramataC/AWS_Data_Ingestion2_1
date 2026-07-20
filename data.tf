# References to infrastructure created in Labs 1.1-1.3 and 2.1.
# This lab only adds DataSync + supporting resources on top of them.

data "aws_vpc" "data_platform" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnet" "private" {
  vpc_id = data.aws_vpc.data_platform.id

  filter {
    name   = "tag:Name"
    values = [var.private_subnet_name]
  }
}

data "aws_security_group" "private_compute" {
  vpc_id = data.aws_vpc.data_platform.id

  filter {
    name   = "tag:Name"
    values = [var.security_group_name]
  }
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "aws_caller_identity" "current" {}

# Shared with Lab 2.3 (S3 Data Lake Foundation) - referenced here, not managed.
# Bucket-level settings (versioning/encryption/public access block) are that
# lab's responsibility; two configs both owning the same bucket's lifecycle
# would fight each other on every apply.
data "aws_s3_bucket" "data_lake" {
  bucket = local.data_lake_bucket_name
}
