resource "aws_subnet" "private" {
  count                   = var.private_subnet_count
  cidr_block              = cidrsubnet(var.vpc_cidr_block, var.subnet_newbits, count.index)
  availability_zone       = local.azs[count.index]
  vpc_id                  = var.vpc_id
  map_public_ip_on_launch = false
  tags = {
    Name       = "${var.system_name}-${var.env_type}-subnet-private${count.index}-${local.azs[count.index]}"
    Network    = "Private"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_route_table" "private" {
  count  = length(aws_subnet.private)
  vpc_id = var.vpc_id
  tags = {
    Name       = "${var.system_name}-${var.env_type}-rtb-private${count.index}"
    Network    = "Private"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# trivy:ignore:AVD-AWS-0104
resource "aws_security_group" "private" {
  count       = length(aws_subnet.private) > 0 ? 1 : 0
  name        = "${var.system_name}-${var.env_type}-sg-private"
  description = "Security group for private subnets"
  vpc_id      = var.vpc_id
  ingress {
    description = "Allow all inbound traffic from the security group itself"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }
  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name       = "${var.system_name}-${var.env_type}-sg-private"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_endpoint" "gateway" {
  for_each          = toset(length(aws_route_table.private) > 0 ? ["s3", "dynamodb"] : [])
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${local.region}.${each.key}"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = aws_route_table.private[*].id
  tags = {
    Name       = "${var.system_name}-${var.env_type}-vpce-gw-${each.key}"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

# trivy:ignore:AVD-AWS-0164
resource "aws_subnet" "public" {
  count                   = var.public_subnet_count
  cidr_block              = cidrsubnet(var.vpc_cidr_block, var.subnet_newbits, count.index + length(local.azs))
  availability_zone       = local.azs[count.index]
  vpc_id                  = var.vpc_id
  map_public_ip_on_launch = true
  tags = {
    Name       = "${var.system_name}-${var.env_type}-subnet-public${count.index}-${local.azs[count.index]}"
    Network    = "Public"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_route_table" "public" {
  count  = length(aws_subnet.public) > 0 ? 1 : 0
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public[0].id
  }
  tags = {
    Name       = "${var.system_name}-${var.env_type}-rtb-public"
    Network    = "Public"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_internet_gateway" "public" {
  count  = length(aws_subnet.public) > 0 ? 1 : 0
  vpc_id = var.vpc_id
  tags = {
    Name       = "${var.system_name}-${var.env_type}-igw"
    Network    = "Public"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id
}
