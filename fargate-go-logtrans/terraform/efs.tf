resource "aws_efs_file_system" "efs" {
  creation_token                  = "fargate-efs"
  provisioned_throughput_in_mibps = "50"
  throughput_mode                 = "provisioned"
 
  tags = {
    Name = "fargate-efs"
  }
}
 

resource "aws_efs_mount_target" "dmz_1a" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = aws_subnet.public_a.id
  security_groups = [
    aws_security_group.efs.id
  ]
}
 
resource "aws_efs_mount_target" "dmz_1c" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = aws_subnet.public_c.id
  security_groups = [
    aws_security_group.efs.id
  ]
}