# tfsec:ignore:aws-ec2-require-vpc-flow-logs-for-all-vpcs
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Application = local.vpc_name
    Network     = "Public"
    Name        = local.vpc_name
    SystemName  = var.system_name
    EnvType     = var.env_type
  }
}

resource "aws_vpc_ipv4_cidr_block_association" "main" {
  for_each   = toset(var.vpc_secondary_cidr_blocks)
  vpc_id     = aws_vpc.main.id
  cidr_block = each.key
}

resource "aws_flow_log" "log" {
  count                = var.vpc_flow_log_s3_bucket_id != null ? 1 : 0
  vpc_id               = aws_vpc.main.id
  log_destination_type = "s3"
  log_destination      = "arn:aws:s3:::${var.vpc_flow_log_s3_bucket_id}/${var.vpc_s3_key_prefix}"
  traffic_type         = "ALL"
  tags = {
    Name       = "${aws_vpc.main.tags.Name}-flow-log"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}
