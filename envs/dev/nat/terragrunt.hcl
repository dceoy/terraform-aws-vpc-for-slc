include "root" {
  path = find_in_parent_folders()
}

dependency "subnet" {
  config_path = "../subnet"
  mock_outputs = {
    public_subnet_ids       = ["subnet-12345678", "subnet-87654321"]
    private_route_table_ids = ["rtb-12345678", "rtb-87654321"]
  }
}

inputs = {
  public_subnet_ids  = dependency.subnet.outputs.public_subnet_ids
  private_subnet_ids = dependency.subnet.outputs.private_subnet_ids
}

terraform {
  source = "${get_repo_root()}/modules/nat"
}
