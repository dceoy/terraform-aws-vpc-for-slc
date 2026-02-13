resource "aws_instance" "server" {
  # checkov:skip=CKV_AWS_126:Detailed monitoring is intentionally disabled for the optional admin instance.
  # checkov:skip=CKV_AWS_135:EBS optimization is not required for the optional admin instance.
  # checkov:skip=CKV2_AWS_41:IAM role is attached through the launch template instance profile.
  count = var.create_ec2_instance ? 1 : 0
  launch_template {
    id      = aws_launch_template.server.id
    version = "$Latest"
  }
  root_block_device {
    encrypted = true
  }
  metadata_options {
    http_tokens = "required"
  }
  user_data         = <<-EOT
                      #!/usr/bin/env bash
                      sudo sh -c 'dnf -y upgrade && dnf clean all && rm -rf /var/cache/dnf'
                      EOT
  source_dest_check = true
  tags = {
    Name       = "${var.system_name}-${var.env_type}-ec2-instance"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_launch_template" "server" {
  name = "${var.system_name}-${var.env_type}-ec2-launch-template"
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = var.ec2_ebs_volume_size
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  }
  image_id      = local.ec2_image_id
  instance_type = var.ec2_instance_type
  key_name      = length(aws_key_pair.ssh) > 0 ? aws_key_pair.ssh[0].key_name : null
  network_interfaces {
    network_interface_id = aws_network_interface.server.id
    device_index         = 0
  }
  iam_instance_profile {
    arn = aws_iam_instance_profile.server.arn
  }
  metadata_options {
    http_tokens = "required"
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name       = "${var.system_name}-${var.env_type}-ec2-launch-template"
      SystemName = var.system_name
      EnvType    = var.env_type
    }
  }
  tags = {
    Name       = "${var.system_name}-${var.env_type}-ec2-launch-template"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_network_interface" "server" {
  subnet_id         = var.private_subnet_id
  security_groups   = var.security_group_ids
  source_dest_check = true
  tags = {
    Name       = "${var.system_name}-${var.env_type}-ec2-network-interface"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_iam_instance_profile" "server" {
  name = "${var.system_name}-${var.env_type}-ec2-instance-profile"
  role = aws_iam_role.server.name
  path = "/"
  tags = {
    Name       = "${var.system_name}-${var.env_type}-ec2-instance-profile"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_iam_role" "server" {
  name                  = "${var.system_name}-${var.env_type}-ec2-instance-role"
  description           = "EC2 instance IAM role"
  force_detach_policies = var.iam_role_force_detach_policies
  path                  = "/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["sts:AssumeRole"]
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
  managed_policy_arns = compact([
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    var.ssm_session_server_iam_policy_arn
  ])
  tags = {
    Name    = "${var.system_name}-${var.env_type}-ec2-instance-role"
    EnvType = var.env_type
  }
}

resource "aws_ssm_parameter" "server" {
  # checkov:skip=CKV2_AWS_34:This parameter stores a non-sensitive instance ID as String.
  count = length(aws_instance.server) > 0 ? 1 : 0
  name  = "/${var.system_name}/${var.env_type}/ec2-instance-id/${aws_instance.server[0].tags.Name}"
  type  = "String"
  value = aws_instance.server[0].id
  tags = {
    Name       = "/${var.system_name}/${var.env_type}/ec2-instance-id/${aws_instance.server[0].tags.Name}"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "tls_private_key" "ssh" {
  count     = var.use_ssh ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh" {
  count      = length(tls_private_key.ssh) > 0 ? 1 : 0
  key_name   = "${var.system_name}-${var.env_type}-ec2-key-pair"
  public_key = tls_private_key.ssh[count.index].public_key_openssh
  tags = {
    Name       = "${var.system_name}-${var.env_type}-ec2-key-pair"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_ssm_parameter" "ssh" {
  # checkov:skip=CKV_AWS_337:Use the default AWS-managed key for this SecureString parameter.
  count = length(tls_private_key.ssh) > 0 ? 1 : 0
  name  = "/${var.system_name}/${var.env_type}/ec2-private-key-pem/${aws_key_pair.ssh[count.index].key_name}"
  type  = "SecureString"
  value = tls_private_key.ssh[count.index].private_key_pem
  tags = {
    Name       = "/${var.system_name}/${var.env_type}/ec2-private-key-pem/${aws_key_pair.ssh[count.index].key_name}"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_iam_role" "session" {
  name                  = "${var.system_name}-${var.env_type}-ec2-ssm-session-role"
  description           = "EC2 SSM session IAM role"
  force_detach_policies = var.iam_role_force_detach_policies
  path                  = "/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["sts:AssumeRole"]
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${local.account_id}:root"
        }
      }
    ]
  })
  managed_policy_arns = compact([var.ssm_session_client_iam_policy_arn])
  tags = {
    Name       = "${var.system_name}-${var.env_type}-ec2-ssm-session-role"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_iam_role_policy" "session" {
  name = "${var.system_name}-${var.env_type}-ec2-ssm-session-policy"
  role = aws_iam_role.session.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat(
      [
        {
          Effect   = "Allow"
          Action   = ["ssm:StartSession"]
          Resource = ["arn:aws:ec2:*:*:instance/*"]
          Condition = {
            StringEquals = {
              "aws:ResourceTag/SystemName" = var.system_name
              "aws:ResourceTag/EnvType"    = var.env_type
            }
          }
        },
        {
          Effect = "Allow"
          Action = [
            "ssm:GetParameters",
            "ssm:GetParameter",
            "ssm:DescribeParameters"
          ]
          Resource = ["arn:aws:ssm:*:*:parameter/*"]
          Condition = {
            StringEquals = {
              "aws:ResourceTag/SystemName" = var.system_name
              "aws:ResourceTag/EnvType"    = var.env_type
            }
          }
        }
      ],
      (
        var.ssm_session_client_iam_policy_arn == null ? [
          {
            Effect = "Allow"
            Action = ["ssm:StartSession"]
            Resource = [
              "arn:aws:ssm:${local.region}:${local.account_id}:document/AWS-StartSSHSession"
            ]
            Condition = {
              BoolIfExists = {
                "ssm:SessionDocumentAccessCheck" = "true"
              }
            }
          }
        ] : []
      )
    )
  })
}
