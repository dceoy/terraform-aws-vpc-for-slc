resource "aws_subnet" "private" {
  count                   = var.private_subnet_count
  cidr_block              = cidrsubnet(local.vpc_cidr_block, var.subnet_newbits, count.index)
  availability_zone       = local.private_subnet_azs[count.index]
  vpc_id                  = var.vpc_id
  map_public_ip_on_launch = false
  tags = {
    Application = "${var.project_name}-${var.env_type}-subnet-private${count.index}"
    Network     = "Private"
    Name        = "${var.project_name}-${var.env_type}-subnet-private${count.index}-${local.private_subnet_azs[count.index]}"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_route_table" "private" {
  count  = var.private_subnet_count
  vpc_id = var.vpc_id
  tags = {
    Name        = "${var.project_name}-${var.env_type}-rtb-private${count.index}"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_route_table_association" "private_route_table_associations" {
  count          = var.private_subnet_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${local.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = aws_route_table.private[*].id
  tags = {
    Name        = "${var.project_name}-${var.env_type}-vpce-gw-s3"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${local.region}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = aws_route_table.private[*].id
  tags = {
    Name        = "${var.project_name}-${var.env_type}-vpce-gw-dynamodb"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_subnet" "public" {
  count                   = var.public_subnet_count
  cidr_block              = cidrsubnet(local.vpc_cidr_block, var.subnet_newbits, count.index + var.private_subnet_count)
  availability_zone       = local.public_subnet_azs[count.index]
  vpc_id                  = var.vpc_id
  map_public_ip_on_launch = true
  tags = {
    Application = "${var.project_name}-${var.env_type}-subnet-public${count.index}"
    Network     = "Public"
    Name        = "${var.project_name}-${var.env_type}-subnet-public${count.index}-${local.public_subnet_azs[count.index]}"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public.id
  }
  tags = {
    Name        = "${var.project_name}-${var.env_type}-rtb-public"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_internet_gateway" "public" {
  vpc_id = var.vpc_id
  tags = {
    Application = "${var.project_name}-${var.env_type}-vpc"
    Network     = "Public"
    Name        = "${var.project_name}-${var.env_type}-igw"
    ProjectName = var.project_name
    EnvType     = var.env_type
  }
}

resource "aws_route_table_association" "public" {
  count          = var.public_subnet_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
