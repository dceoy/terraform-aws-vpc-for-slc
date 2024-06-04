output "log_s3_bucket_id" {
  description = "Log S3 bucket ID"
  value       = length(aws_s3_bucket.log) > 0 ? aws_s3_bucket.log[0].id : null
}

output "log_s3_iam_policy_arn" {
  description = "Log S3 IAM policy ARN"
  value       = length(aws_iam_policy.log) > 0 ? aws_iam_policy.log[0].arn : null
}
