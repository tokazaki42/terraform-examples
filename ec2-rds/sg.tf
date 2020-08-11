resource "aws_security_group" "web-instance-sg" {
  name   = "web-instance-sg"
  vpc_id = aws_vpc.example-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "praivate-db-sg" {
    name = "praivate-db-sg"
  vpc_id = aws_vpc.example-vpc.id
    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
       security_groups = [aws_security_group.web-instance-sg.id]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      Name = "public-db-sg"
    }
}