output "data_lake_bucket_name" {
  description = "Name of the created data lake S3 bucket"
  value       = aws_s3_bucket.data_lake.id
}

output "datasync_test_server_id" {
  description = "Instance ID of the simulated on-prem file server (null if create_test_server = false)"
  value       = var.create_test_server ? aws_instance.datasync_test_server[0].id : null
}

output "datasync_source_location_arn" {
  description = "ARN of the onprem-s3-raw-location DataSync source location"
  value       = aws_datasync_location_s3.onprem_raw.arn
}

output "datasync_destination_location_arn" {
  description = "ARN of the aws-s3-processed-location DataSync destination location"
  value       = aws_datasync_location_s3.aws_processed.arn
}

output "datasync_task_arn" {
  description = "ARN of the raw-to-processed-sync DataSync task"
  value       = aws_datasync_task.raw_to_processed.arn
}

output "datasync_role_arn" {
  description = "ARN of the DataSyncS3Role IAM role used by both locations"
  value       = aws_iam_role.datasync_s3.arn
}

output "datasync_log_group_name" {
  description = "CloudWatch log group receiving DataSync task execution logs"
  value       = aws_cloudwatch_log_group.datasync_task.name
}

output "sns_topic_arn" {
  description = "SNS topic notified on TaskExecutionsFailed >= 1"
  value       = aws_sns_topic.datasync_notifications.arn
}
