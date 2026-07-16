# Lab 1.3 prerequisite (not previously provisioned): the data lake bucket
# that DataSync reads from (raw/) and writes to (processed/).

# Access logging would require provisioning a second bucket (itself needing the
# same hardening) just to log access to a few KB of sample data - not proportionate
# for this teaching lab.
#tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "data_lake" {
  bucket = local.data_lake_bucket_name

  tags = merge(var.tags, {
    Name = local.data_lake_bucket_name
  })
}

resource "aws_s3_bucket_versioning" "data_lake" {
  bucket = aws_s3_bucket.data_lake.id

  versioning_configuration {
    status = "Enabled"
  }
}

# SSE-S3 (AES256) is used instead of a dedicated KMS CMK: this bucket holds a
# handful of non-sensitive sample CSVs for a teaching lab, and a CMK adds a
# recurring ~$1/month charge that isn't proportionate here.
#tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket_server_side_encryption_configuration" "data_lake" {
  bucket = aws_s3_bucket.data_lake.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "data_lake" {
  bucket = aws_s3_bucket.data_lake.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "raw_folder" {
  bucket  = aws_s3_bucket.data_lake.id
  key     = var.raw_prefix
  content = ""
}

resource "aws_s3_object" "processed_folder" {
  bucket  = aws_s3_bucket.data_lake.id
  key     = var.processed_prefix
  content = ""
}
