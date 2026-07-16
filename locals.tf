locals {
  data_lake_bucket_name = var.data_lake_bucket_name != "" ? var.data_lake_bucket_name : "data-lake-prod-${data.aws_caller_identity.current.account_id}"
}
