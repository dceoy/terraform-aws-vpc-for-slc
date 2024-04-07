provider "aws" {
  region = var.region
  default_tags {
    tags = {
      SystemName = var.system_name
      EnvType    = var.env_type
    }
  }
}
