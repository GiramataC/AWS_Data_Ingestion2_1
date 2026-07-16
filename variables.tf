variable "aws_region" {
  description = "AWS region for the lab (must match Labs 1.1-1.3 and 2.1)"
  type        = string
  default     = "eu-west-1"
}

variable "vpc_name" {
  description = "Name tag of the existing VPC created in Lab 1.2"
  type        = string
  default     = "data-platform-vpc"
}

variable "private_subnet_name" {
  description = "Name tag of the existing private subnet to launch the simulated on-prem server into"
  type        = string
  default     = "private-subnet-1b"
}

variable "security_group_name" {
  description = "Name tag of the existing private-compute security group"
  type        = string
  default     = "sg-private-compute"
}

variable "data_lake_bucket_name" {
  description = "Name of the S3 data lake bucket. Leave blank to auto-generate a globally-unique name from the account ID (data-lake-prod-<account_id>)."
  type        = string
  default     = ""
}

variable "raw_prefix" {
  description = "Prefix (folder) in the data lake bucket that simulates the on-prem source"
  type        = string
  default     = "raw/"
}

variable "processed_prefix" {
  description = "Prefix (folder) in the data lake bucket that is the DataSync destination"
  type        = string
  default     = "processed/"
}

variable "create_test_server" {
  description = "Whether to launch the simulated on-prem EC2 test server. Set false if an org SCP denies ec2:RunInstances - the DataSync pipeline is S3-to-S3 and doesn't require it."
  type        = bool
  default     = true
}

variable "instance_type" {
  description = "Instance type for the simulated on-prem file server. This account's org SCP denies the t2 family - use t3/t4g."
  type        = string
  default     = "t3.micro"
}

variable "datasync_schedule_expression" {
  description = "Cron expression for the daily DataSync task run"
  type        = string
  default     = "cron(0 3 * * ? *)"
}

variable "alarm_notification_email" {
  description = "Email address subscribed to the datasync-notifications SNS topic (leave blank to skip subscription)"
  type        = string
  default     = ""
}

variable "enable_incremental_test_file" {
  description = "Set true during Part 7 to upload new_customers.csv and exercise incremental sync"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default = {
    Project = "data-platform"
    Lab     = "2.2-datasync"
  }
}
