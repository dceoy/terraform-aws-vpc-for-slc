include "root" {
  path = find_in_parent_folders()
}

dependency "s3" {
  config_path = "../s3"
  mock_outputs = {
    awslogs_s3_iam_policy_arn = "arn:aws:iam::123456789012:policy/log-s3-iam-policy"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

dependency "subnet" {
  config_path = "../subnet"
  mock_outputs = {
    private_subnet_ids        = ["subnet-12345678", "subnet-87654321"]
    private_security_group_id = "sg-12345678"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

dependency "ssm" {
  config_path = "../ssm"
  mock_outputs = {
    ssm_session_client_iam_policy_arn = "arn:aws:iam::123456789012:policy/ssm-session-client-iam-policy"
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

inputs = {
  private_subnet_id                 = dependency.subnet.outputs.private_subnet_ids[0]
  security_group_ids                = [dependency.subnet.outputs.private_security_group_id]
  ssm_session_server_iam_policy_arn = dependency.s3.outputs.awslogs_s3_iam_policy_arn
  ssm_session_client_iam_policy_arn = dependency.ssm.outputs.ssm_session_client_iam_policy_arn
}

terraform {
  source = "${get_repo_root()}/modules/ec2"
}
