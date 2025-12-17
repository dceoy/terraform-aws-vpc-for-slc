output "io_s3_bucket_id" {
  description = "IO S3 bucket ID"
  value       = contains(keys(aws_s3_bucket.storage), "io") ? aws_s3_bucket.storage["io"].id : null
}

output "io_s3_bucket_domain_name" {
  description = "IO S3 bucket domain name"
  value       = contains(keys(aws_s3_bucket.storage), "io") ? aws_s3_bucket.storage["io"].bucket_domain_name : null
}

output "io_s3_bucket_regional_domain_name" {
  description = "IO S3 bucket regional domain name"
  value       = contains(keys(aws_s3_bucket.storage), "io") ? aws_s3_bucket.storage["io"].bucket_regional_domain_name : null
}

output "awslogs_s3_bucket_id" {
  description = "AWS service logs S3 bucket ID"
  value       = contains(keys(aws_s3_bucket.storage), "awslogs") ? aws_s3_bucket.storage["awslogs"].id : null
}

output "awslogs_s3_bucket_domain_name" {
  description = "AWS service logs S3 bucket domain name"
  value       = contains(keys(aws_s3_bucket.storage), "awslogs") ? aws_s3_bucket.storage["awslogs"].bucket_domain_name : null
}

output "awslogs_s3_bucket_regional_domain_name" {
  description = "AWS service logs S3 bucket regional domain name"
  value       = contains(keys(aws_s3_bucket.storage), "awslogs") ? aws_s3_bucket.storage["awslogs"].bucket_regional_domain_name : null
}

output "s3logs_s3_bucket_id" {
  description = "AWS service logs S3 bucket ID"
  value       = contains(keys(aws_s3_bucket.storage), "s3logs") ? aws_s3_bucket.storage["s3logs"].id : null
}

output "s3logs_s3_bucket_domain_name" {
  description = "AWS service logs S3 bucket domain name"
  value       = contains(keys(aws_s3_bucket.storage), "s3logs") ? aws_s3_bucket.storage["s3logs"].bucket_domain_name : null
}

output "s3logs_s3_bucket_regional_domain_name" {
  description = "AWS service logs S3 bucket regional domain name"
  value       = contains(keys(aws_s3_bucket.storage), "s3logs") ? aws_s3_bucket.storage["s3logs"].bucket_regional_domain_name : null
}

output "s3_iam_policy_arn" {
  description = "S3 IAM policy ARN"
  value       = length(aws_iam_policy.storage) > 0 ? aws_iam_policy.storage[0].arn : null
}
