# Lab 1.3 prerequisite (not previously provisioned): the data lake bucket
# that DataSync reads from (raw/) and writes to (processed/).

resource "aws_s3_bucket" "data_lake" {
  bucket = local.data_lake_bucket_name

  tags = merge(var.tags, {
    Name = local.data_lake_bucket_name
  })
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
