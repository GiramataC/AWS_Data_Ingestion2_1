# Part 4/8: task execution logging + failure alarm

# Holds only DataSync transfer metadata (file names/sizes/timestamps) for a
# teaching lab, not sensitive data; a dedicated CMK adds a recurring ~$1/month
# charge that isn't proportionate here.
#tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "datasync_task" {
  name              = "/aws/datasync/raw-to-processed-sync"
  retention_in_days = 30
  tags              = var.tags
}

data "aws_iam_policy_document" "datasync_log_publish" {
  statement {
    sid    = "DataSyncLogsToCloudWatchLogs"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["datasync.amazonaws.com"]
    }

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["${aws_cloudwatch_log_group.datasync_task.arn}:*"]
  }
}

resource "aws_cloudwatch_log_resource_policy" "datasync" {
  policy_name     = "DataSyncLogPolicy"
  policy_document = data.aws_iam_policy_document.datasync_log_publish.json
}

# Part 8: SNS topic + alarm on TaskExecutionsFailed.
# Uses the AWS-managed key (not a dedicated CMK) for encryption at rest - it's
# free, unlike a customer-managed key which bills ~$1/month regardless of use.
# Notification payloads are just alarm state text (task ARN, alarm name), not
# sensitive data, so a dedicated CMK isn't proportionate for this teaching lab.
#tfsec:ignore:aws-sns-topic-encryption-use-cmk
resource "aws_sns_topic" "datasync_notifications" {
  name              = "datasync-notifications"
  kms_master_key_id = "alias/aws/sns"
  tags              = var.tags
}

resource "aws_sns_topic_subscription" "email" {
  count     = var.alarm_notification_email != "" ? 1 : 0
  topic_arn = aws_sns_topic.datasync_notifications.arn
  protocol  = "email"
  endpoint  = var.alarm_notification_email
}

resource "aws_cloudwatch_metric_alarm" "datasync_task_failed" {
  alarm_name          = "datasync-raw-to-processed-task-failures"
  alarm_description   = "Fires when the raw-to-processed-sync DataSync task reports a failed execution"
  namespace           = "AWS/DataSync"
  metric_name         = "TaskExecutionsFailed"
  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "notBreaching"

  dimensions = {
    TaskId = aws_datasync_task.raw_to_processed.id
  }

  alarm_actions = [aws_sns_topic.datasync_notifications.arn]
  ok_actions    = [aws_sns_topic.datasync_notifications.arn]

  tags = var.tags
}
