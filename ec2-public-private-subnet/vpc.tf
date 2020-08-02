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
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "public-a"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id            = aws_vpc.example-vpc.id
  cidr_block        = "10.10.2.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "public-c"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public.id
}

##################################################################
## Private Network 
##################################################################


resource "aws_eip" "example-natgateway" {
  vpc = true

  tags = {
    Name = "example-vpc-natgateway-eip"
  }
}

resource "aws_nat_gateway" "private-nat" {
  allocation_id = aws_eip.example-natgateway.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name = "example-vpc-natgateway"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.example-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.private-nat.id
  }
  tags = {
    Name = "private-net"
  }
}


resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.example-vpc.id
  cidr_block        = "10.10.21.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "private-a"
  }
}

resource "aws_subnet" "private_c" {
  vpc_id            = aws_vpc.example-vpc.id
  cidr_block        = "10.10.22.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "private-c"
  }
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_c" {
  subnet_id      = aws_subnet.private_c.id
  route_table_id = aws_route_table.private.id
}

output "private_a" {
  value = {
    id = aws_subnet.private_a.id
  }
}

output "private_c" {
  value = {
    id = aws_subnet.private_c.id
  }
}

output "public_a" {
  value = {
    id = aws_subnet.public_a.id
  }
}

output "public_c" {
  value = {
    id = aws_subnet.public_c.id
  }
}

##################################################################
## VPC Endpoints for Session Manager
##################################################################

resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = aws_vpc.example-vpc.id
  service_name      = "com.amazonaws.ap-northeast-1.ssm"
  vpc_endpoint_type = "Interface"
  security_group_ids = [
    aws_security_group.private-ssm-sg.id,
  ]

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id            = aws_vpc.example-vpc.id
  service_name      = "com.amazonaws.ap-northeast-1.ssmmessages"
  vpc_endpoint_type = "Interface"
  security_group_ids = [
    aws_security_group.private-ssm-sg.id,
  ]

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "c2message" {
  vpc_id            = aws_vpc.example-vpc.id
  service_name      = "com.amazonaws.ap-northeast-1.ec2messages"
  vpc_endpoint_type = "Interface"
  security_group_ids = [
    aws_security_group.private-ssm-sg.id,
  ]

  private_dns_enabled = true
}
