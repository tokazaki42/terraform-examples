resource "aws_instance" "bastion-ec2" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.bastion-instance-sg.id]
  subnet_id                   = aws_subnet.public_a.id
  key_name                    = aws_key_pair.ssh-key.key_name
  associate_public_ip_address = true
  user_data                   = file("./userdata.sh")

  root_block_device {
    volume_type = "gp2"
    volume_size = var.gp2_volume_size
  }

  iam_instance_profile = aws_iam_instance_profile.systems_manager.name

  tags = {
    Name = "bastion-instance"
  }
}

resource "aws_instance" "private-ec2" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.private-instance-sg.id]
  subnet_id                   = aws_subnet.private_a.id
  key_name                    = aws_key_pair.ssh-key.key_name
  associate_public_ip_address = true
  user_data                   = file("./userdata.sh")

  root_block_device {
    volume_type = "gp2"
    volume_size = var.gp2_volume_size
  }

  iam_instance_profile = aws_iam_instance_profile.systems_manager.name

  tags = {
    Name = "private-instance"
  }
}

resource "aws_key_pair" "ssh-key" {
  key_name   = "example-operation-pubkey"
  public_key = file(var.pubkey_file_path)
}
