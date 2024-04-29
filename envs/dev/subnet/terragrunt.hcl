include "root" {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_id = "vpc-12345678"
  }
}

inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id
}

terraform {
  source = "${get_repo_root()}/modules/subnet"
}
