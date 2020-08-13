resource "aws_vpc" "this" {
  cidr_block = "10.1.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "virtual-office-vpc"
  }
}


# InternetGateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

# RouteTable
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    Name = "public"
  }
}

# Subnet
resource "aws_subnet" "public_a" {
  vpc_id = aws_vpc.this.id
  cidr_block = "10.1.1.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "public-a"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id = aws_vpc.this.id
  cidr_block = "10.1.2.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "public-c"
  }
}

# SubnetRouteTableAssociation
resource "aws_route_table_association" "public_a" {
    subnet_id = aws_subnet.public_a.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_c" {
    subnet_id = aws_subnet.public_c.id
    route_table_id = aws_route_table.public.id
}
