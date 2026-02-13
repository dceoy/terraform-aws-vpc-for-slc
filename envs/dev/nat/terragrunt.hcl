include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "subnet" {
  config_path = "../subnet"
  mock_outputs = {
    private_route_table_ids = ["rtb-12345678", "rtb-87654321"]
  }
  mock_outputs_merge_strategy_with_state = "shallow"
}

inputs = {
  private_route_table_ids = dependency.subnet.outputs.private_route_table_ids
}

terraform {
  source = "${get_repo_root()}/modules/nat"
}
