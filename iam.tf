# Parts 2-3: DataSyncS3Role, shared by the source and destination S3 locations.

data "aws_iam_policy_document" "datasync_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["datasync.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "datasync_s3" {
  name               = "DataSyncS3Role"
  assume_role_policy = data.aws_iam_policy_document.datasync_assume_role.json
  tags               = var.tags
}

data "aws_iam_policy_document" "datasync_s3_access" {
  statement {
    sid    = "BucketLevelAccess"
    effect = "Allow"
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
    ]
    resources = [aws_s3_bucket.data_lake.arn]
  }

  statement {
    sid    = "ObjectLevelAccess"
    effect = "Allow"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:GetObjectTagging",
      "s3:ListMultipartUploadParts",
      "s3:PutObject",
      "s3:PutObjectTagging",
    ]
    resources = ["${aws_s3_bucket.data_lake.arn}/*"]
  }
}

resource "aws_iam_role_policy" "datasync_s3_access" {
  name   = "DataSyncS3Access"
  role   = aws_iam_role.datasync_s3.id
  policy = data.aws_iam_policy_document.datasync_s3_access.json
}

# DataSync's AssumeRole check can run before IAM's eventual consistency
# catches up on a freshly created role, so give it a moment.
resource "time_sleep" "datasync_role_propagation" {
  depends_on      = [aws_iam_role_policy.datasync_s3_access]
  create_duration = "20s"
}
