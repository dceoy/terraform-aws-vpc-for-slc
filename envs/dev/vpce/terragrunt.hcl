include "root" {
  path = find_in_parent_folders()
}

dependency "subnet" {
  config_path = "../subnet"
  mock_outputs = {
    private_route_table_ids   = ["rtb-12345678", "rtb-87654321"]
    private_security_group_id = "sg-12345678"
  }
}

inputs = {
  private_subnet_ids = dependency.subnet.outputs.private_subnet_ids
  security_group_ids = [dependency.subnet.outputs.private_security_group_id]
}

terraform {
  source = "${get_repo_root()}/modules/vpce"
}
