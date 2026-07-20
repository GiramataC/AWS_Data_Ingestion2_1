# Part 2: source location - onprem-s3-raw-location
resource "aws_datasync_location_s3" "onprem_raw" {
  s3_bucket_arn = data.aws_s3_bucket.data_lake.arn
  subdirectory  = "/${var.raw_prefix}"

  s3_config {
    bucket_access_role_arn = aws_iam_role.datasync_s3.arn
  }

  tags = merge(var.tags, {
    Name = "onprem-s3-raw-location"
  })

  depends_on = [time_sleep.datasync_role_propagation]
}

# Part 3: destination location - aws-s3-processed-location
resource "aws_datasync_location_s3" "aws_processed" {
  s3_bucket_arn = data.aws_s3_bucket.data_lake.arn
  subdirectory  = "/${var.processed_prefix}"

  s3_config {
    bucket_access_role_arn = aws_iam_role.datasync_s3.arn
  }

  tags = merge(var.tags, {
    Name = "aws-s3-processed-location"
  })

  depends_on = [time_sleep.datasync_role_propagation]
}

# Part 4: task - raw-to-processed-sync
resource "aws_datasync_task" "raw_to_processed" {
  name                     = "raw-to-processed-sync"
  source_location_arn      = aws_datasync_location_s3.onprem_raw.arn
  destination_location_arn = aws_datasync_location_s3.aws_processed.arn
  cloudwatch_log_group_arn = aws_cloudwatch_log_group.datasync_task.arn

  options {
    verify_mode            = "POINT_IN_TIME_CONSISTENT" # "Verify data integrity"
    overwrite_mode         = "ALWAYS"
    transfer_mode          = "CHANGED" # sync: only new/modified files
    preserve_deleted_files = "PRESERVE"
    atime                  = "BEST_EFFORT"
    mtime                  = "PRESERVE"
    task_queueing          = "ENABLED"
    log_level              = "TRANSFER"
    posix_permissions      = "NONE" # not applicable to S3-to-S3 transfers
    uid                    = "NONE"
    gid                    = "NONE"
  }

  schedule {
    schedule_expression = var.datasync_schedule_expression
  }

  tags = merge(var.tags, {
    Name = "raw-to-processed-sync"
  })

  depends_on = [aws_cloudwatch_log_resource_policy.datasync]
}
