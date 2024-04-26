include "root" {
  path = find_in_parent_folders()
}

dependency "subnet" {
  config_path = "../subnet"
  mock_outputs = {
    private_subnet_ids        = ["subnet-12345678", "subnet-87654321"]
    private_security_group_id = "sg-12345678"
  }
}

dependency "kms" {
  config_path = "../kms"
  mock_outputs = {
    kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }
}

dependency "ssm" {
  config_path = "../ssm"
  mock_outputs = {
    ssm_session_document_name      = "ssm-session-document"
    ssm_session_kms_key_arn        = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
    ssm_session_log_iam_policy_arn = "arn:aws:iam::123456789012:policy/ssm-session-log-policy"
  }
}

inputs = {
  private_subnet_id              = dependency.subnet.outputs.private_subnet_ids[0]
  security_group_ids             = [dependency.subnet.outputs.private_security_group_id]
  kms_key_arn                    = dependency.kms.outputs.kms_key_arn
  ssm_session_document_name      = dependency.ssm.outputs.ssm_session_document_name
  ssm_session_log_iam_policy_arn = dependency.ssm.outputs.ssm_session_log_iam_policy_arn
}

terraform {
  source = "${get_repo_root()}/modules/ec2"
}
