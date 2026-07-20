# The data lake bucket itself (data.aws_s3_bucket.data_lake, in data.tf) is
# shared with Lab 2.3 and not managed here - only these raw/processed folder
# markers, which are Lab 2.2-specific, are Terraform-managed.

resource "aws_s3_object" "raw_folder" {
  bucket  = data.aws_s3_bucket.data_lake.id
  key     = var.raw_prefix
  content = ""
}

resource "aws_s3_object" "processed_folder" {
  bucket  = data.aws_s3_bucket.data_lake.id
  key     = var.processed_prefix
  content = ""
}
