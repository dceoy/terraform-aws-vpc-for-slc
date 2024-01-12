resource "aws_instance" "server" {
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
  user_data = <<-EOF
              #!/usr/bin/env bash
              sudo sh -c 'dnf -y upgrade && dnf clean all && rm -rf /var/cache/dnf'
              EOF
  tags = {
    Name        = "${var.project_name}-${var.env_type}-ec2-instance"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_launch_template" "server" {
  name = "${var.project_name}-${var.env_type}-ec2-launch-template"
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = var.ebs_volume_size
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  }
  image_id      = local.image_id
  instance_type = var.instance_type
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
      Name        = "${var.project_name}-${var.env_type}-ec2-launch-template"
      ProjectName = var.project_name
      EnvType     = var.env_type
    }
  }
}

resource "aws_network_interface" "server" {
  subnet_id         = var.private_subnet_id
  source_dest_check = false
  security_groups   = var.security_group_ids
  tags = {
    Name        = "${var.project_name}-${var.env_type}-ec2-network-interface"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_iam_instance_profile" "server" {
  name = "${var.project_name}-${var.env_type}-ec2-instance-profile"
  role = aws_iam_role.server.name
  path = "/"
}

resource "aws_iam_role" "server" {
  name = "${var.project_name}-${var.env_type}-ec2-instance-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
  path                = "/"
  tags = {
    Name    = "${var.project_name}-${var.env_type}-ec2-instance-role"
    EnvType = var.env_type
  }
}

resource "aws_key_pair" "ssh" {
  count      = length(tls_private_key.ssh) > 0 ? 1 : 0
  key_name   = "${var.project_name}-${var.env_type}-ec2-key-pair"
  public_key = tls_private_key.ssh[count.index].public_key_openssh
  tags = {
    Name        = "${var.project_name}-${var.env_type}-ec2-key-pair"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_ssm_parameter" "ssh" {
  count = length(tls_private_key.ssh) > 0 ? 1 : 0
  name  = "/ec2/private-key-pem/${aws_key_pair.ssh[count.index].key_name}"
  type  = "SecureString"
  value = tls_private_key.ssh[count.index].private_key_pem
}

resource "tls_private_key" "ssh" {
  count     = var.use_ssh ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_iam_role" "client" {
  count = length(tls_private_key.ssh) > 0 ? 1 : 0
  name  = "${aws_instance.server.tags.Name}-ssm-ssh-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["sts:AssumeRole"]
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
  inline_policy {
    name = "${aws_instance.server.tags.Name}-ssm-ssh-policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = ["ssm:StartSession"]
          Effect = "Allow"
          Resource = [
            aws_instance.server.arn,
            "arn:aws:ssm:${local.region}:${local.account_id}:document/AWS-StartSSHSession"
          ]
          Condition = {
            BoolIfExists = {
              "ssm:SessionDocumentAccessCheck" = "true"
            }
          }
        }
      ]
    })
  }
  path = "/"
  tags = {
    Name        = "${aws_instance.server.tags.Name}-ssm-ssh-role"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}
