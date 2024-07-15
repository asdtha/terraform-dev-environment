resource "aws_vpc" "vpc_dev" {
  cidr_block           = "10.155.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "dev_public_subnet" {
  vpc_id                  = aws_vpc.vpc_dev.id
  cidr_block              = "10.155.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "dev_public"
  }
}

resource "aws_internet_gateway" "dev_internet_gateway" {
  vpc_id = aws_vpc.vpc_dev.id

  tags = {
    Name = "dev_igw"
  }

}

resource "aws_route_table" "dev_public_rt" {
  vpc_id = aws_vpc.vpc_dev.id

  tags = {
    Name = "dev_public_rt"
  }

}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.dev_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.dev_internet_gateway.id
}

resource "aws_route_table_association" "dev_public_assoc" {
  subnet_id = aws_subnet.dev_public_subnet.id
  route_table_id = aws_route_table.dev_public_rt.id

}