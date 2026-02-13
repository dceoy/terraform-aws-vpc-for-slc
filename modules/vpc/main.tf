# trivy:ignore:AVD-AWS-0178
resource "aws_vpc" "main" {
  # checkov:skip=CKV2_AWS_12:Default security group hardening is managed outside this module.
  cidr_block                       = var.vpc_cidr_block
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = var.vpc_assign_generated_ipv6_cidr_block
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

resource "aws_flow_log" "s3" {
  count                    = var.vpc_flow_log_s3_bucket_id != null ? 1 : 0
  vpc_id                   = aws_vpc.main.id
  log_destination_type     = "s3"
  log_destination          = "arn:aws:s3:::${var.vpc_flow_log_s3_bucket_id}/${var.vpc_flow_log_s3_key_prefix}"
  traffic_type             = var.vpc_flow_log_traffic_type
  max_aggregation_interval = var.vpc_flow_log_max_aggregation_interval
  tags = {
    Name       = "${aws_vpc.main.tags.Name}-s3-flow-log"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_flow_log" "logs" {
  count                    = length(aws_iam_role.flowlog) > 0 ? 1 : 0
  vpc_id                   = aws_vpc.main.id
  log_destination_type     = "cloud-watch-logs"
  log_destination          = aws_cloudwatch_log_group.flowlog[count.index].arn
  iam_role_arn             = aws_iam_role.flowlog[count.index].arn
  traffic_type             = var.vpc_flow_log_traffic_type
  max_aggregation_interval = var.vpc_flow_log_max_aggregation_interval
  tags = {
    Name       = "${aws_vpc.main.tags.Name}-logs-flow-log"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

# trivy:ignore:avd-aws-0017
resource "aws_cloudwatch_log_group" "flowlog" {
  count             = var.create_vpc_flow_log_group ? 1 : 0
  name              = "/${var.system_name}/${var.env_type}/vpc/flow-log/${aws_vpc.main.tags.Name}"
  retention_in_days = var.cloudwatch_logs_retention_in_days
  kms_key_id        = var.kms_key_arn
  tags = {
    Name       = "/${var.system_name}/${var.env_type}/vpc-flow-logs/${aws_vpc.main.tags.Name}"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_iam_role" "flowlog" {
  count                 = length(aws_cloudwatch_log_group.flowlog) > 0 ? 1 : 0
  name                  = "${var.system_name}-${var.env_type}-vpc-flow-log-iam-role"
  description           = "VPC flow log IAM role"
  force_detach_policies = var.iam_role_force_detach_policies
  path                  = "/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowVPCFlowLogsToAssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = {
    Name       = "${var.system_name}-${var.env_type}-vpc-flow-log-iam-role"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_iam_role_policy" "flowlog" {
  count = length(aws_iam_role.flowlog) > 0 ? 1 : 0
  role  = aws_iam_role.flowlog[count.index].id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat(
      [
        {
          Sid      = "AllowDescribeLogGroups"
          Effect   = "Allow"
          Action   = ["logs:DescribeLogGroups"]
          Resource = ["arn:aws:logs:${local.region}:${local.account_id}:log-group:*"]
        },
        {
          Sid    = "AllowLogStreamAccess"
          Effect = "Allow"
          Action = [
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "logs:DescribeLogStreams"
          ]
          Resource = ["${aws_cloudwatch_log_group.flowlog[count.index].arn}:*"]
        }
      ],
      (
        var.kms_key_arn != null ? [
          {
            Sid      = "AllowKMSGenerateDataKey"
            Effect   = "Allow"
            Action   = ["kms:GenerateDataKey"]
            Resource = [var.kms_key_arn]
          }
        ] : []
      )
    )
  })
}
