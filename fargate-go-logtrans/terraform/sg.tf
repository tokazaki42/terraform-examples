resource "aws_security_group" "instance-sg" {
  name   = "instance-sg"
  vpc_id = aws_vpc.example-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
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

output "securitygroup" {
  value = {
    instance-sg_id = aws_security_group.instance-sg.id
  }
}



resource "aws_security_group" "efs" {
  name        = "efs-sg"
  description = "for EFS"
  vpc_id      = aws_vpc.example-vpc.id
}

resource "aws_security_group_rule" "from_fargate_to_efs" {
  security_group_id        = aws_security_group.efs.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 2049
  to_port                  = 2049
  source_security_group_id = aws_security_group.instance-sg.id
  description              = "from_fargate_to_efs"
}

resource "aws_security_group_rule" "egress_efs" {
  security_group_id = aws_security_group.efs.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Outbound ALL"
}
