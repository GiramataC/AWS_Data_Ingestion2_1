# Step 1.3: sample "on-prem" files pre-loaded into raw/, the DataSync source prefix.

locals {
  sample_files = {
    "customer_master.csv" = "sample_data/customer_master.csv"
    "sales_history.csv"   = "sample_data/sales_history.csv"
    "transaction_log.csv" = "sample_data/transaction_log.csv"
  }
}

resource "aws_s3_object" "raw_sample_files" {
  for_each = local.sample_files

  bucket       = data.aws_s3_bucket.data_lake.id
  key          = "${var.raw_prefix}${each.key}"
  source       = "${path.module}/${each.value}"
  etag         = filemd5("${path.module}/${each.value}")
  content_type = "text/csv"
  tags         = var.tags
}

# Part 7: incremental sync test file. Toggle enable_incremental_test_file = true
# and re-apply to drop a new file into raw/ without touching the existing three.
resource "aws_s3_object" "incremental_test_file" {
  count = var.enable_incremental_test_file ? 1 : 0

  bucket       = data.aws_s3_bucket.data_lake.id
  key          = "${var.raw_prefix}new_customers.csv"
  source       = "${path.module}/sample_data/new_customers.csv"
  etag         = filemd5("${path.module}/sample_data/new_customers.csv")
  content_type = "text/csv"
  tags         = var.tags
}
