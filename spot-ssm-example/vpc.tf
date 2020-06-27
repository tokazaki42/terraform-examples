resource "aws_vpc" "example-vpc" {
  cidr_block           = "10.10.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "example-vpc"
  }
}

resource "aws_internet_gateway" "example-vpc-ig" {
  vpc_id = aws_vpc.example-vpc.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.example-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example-vpc-ig.id
  }
  tags = {
    Name = "public"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.example-vpc.id
  cidr_block        = "10.10.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "public-a"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

