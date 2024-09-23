output "awslogs_s3_bucket_id" {
  description = "AWS service logs S3 bucket ID"
  value       = length(aws_s3_bucket.awslogs) > 0 ? aws_s3_bucket.awslogs[0].id : null
}

output "awslogs_s3_iam_policy_arn" {
  description = "AWS service logs S3 IAM policy ARN"
  value       = length(aws_iam_policy.awslogs) > 0 ? aws_iam_policy.awslogs[0].arn : null
}
