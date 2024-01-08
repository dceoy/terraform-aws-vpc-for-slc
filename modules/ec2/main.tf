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
              {
                echo '{'
                echo '  "logs": {'
                echo '    "cloudWatchLogGroup": "${aws_cloudwatch_log_group.server.name}",'
                echo '    "cloudWatchEncryptionEnabled": true,'
                echo '    "cloudWatchStreamingEnabled": true'
                echo '  }'
                echo '}'
              } | sudo tee /etc/amazon/ssm/amazon-ssm-agent.json
              sudo systemctl restart amazon-ssm-agent
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
  key_name      = aws_key_pair.server.key_name
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
          Service = ["ec2.amazonaws.com", "ssm.amazonaws.com"]
        }
      }
    ]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
  inline_policy {
    name = "${var.project_name}-${var.env_type}-ec2-instance-role-policy"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Action = [
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          Effect   = "Allow",
          Resource = [aws_cloudwatch_log_group.server.arn]
        }
      ]
    })
  }
  path = "/"
  tags = {
    Name    = "${var.project_name}-${var.env_type}-ec2-instance-role"
    EnvType = var.env_type
  }
}

resource "aws_key_pair" "server" {
  key_name   = "${var.project_name}-${var.env_type}-ec2-key-pair"
  public_key = tls_private_key.server.public_key_openssh
  tags = {
    Name        = "${var.project_name}-${var.env_type}-ec2-key-pair"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "tls_private_key" "server" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "server" {
  filename        = "${var.project_name}-${var.env_type}-ec2-key-pair.pem"
  content         = tls_private_key.server.private_key_pem
  file_permission = "0600"
}

resource "aws_cloudwatch_log_group" "server" {
  name              = "/aws/ssm/ec2/${var.project_name}-${var.env_type}-ec2-instance"
  retention_in_days = 14
  tags = {
    Name        = "${var.project_name}-${var.env_type}-ssm-ec2-log-group"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}
