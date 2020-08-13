
resource "aws_security_group" "allow-rdp" {
  name   = "allow-rdp"
  vpc_id = aws_vpc.this.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = [local.allowed-cidr]
  }

  tags = {
    Name = "allow-rdp-insubnet"
  }

  description = "virtual-office-rdp"

}



data http ifconfig {
  url = "http://ipv4.icanhazip.com/"
}
variable allowed-cidr {
  default = null
}

locals {
  current-ip   = chomp(data.http.ifconfig.body)
  allowed-cidr = (var.allowed-cidr == null) ? "${local.current-ip}/32" : var.allowed-cidr
}
