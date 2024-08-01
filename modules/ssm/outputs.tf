output "ssm_session_document_name" {
  description = "SSM session document name"
  value       = length(aws_ssm_document.session) > 0 ? local.ssm_session_document_name : null
}

output "ssm_session_client_iam_policy_arn" {
  description = "SSM session client IAM policy ARN"
  value       = length(aws_iam_policy.client) > 0 ? aws_iam_policy.client[0].arn : null
}
