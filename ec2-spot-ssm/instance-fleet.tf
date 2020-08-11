data aws_ssm_parameter amzn2_ami {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}


# Spot Fleet Request
resource "aws_spot_fleet_request" "spot-ssm-example-spot-request" {
  iam_fleet_role = aws_iam_role.role.arn

  target_capacity                     = 1
  terminate_instances_with_expiration = true
  wait_for_fulfillment                = "true"

  launch_specification {
     ami                         = data.aws_ssm_parameter.amzn2_ami.value
    instance_type               = "t3.medium"
    subnet_id                   = aws_subnet.public_a.id
    associate_public_ip_address = true

    iam_instance_profile = aws_iam_instance_profile.systems_manager.name

        root_block_device {
          volume_size = var.gp2_volume_size
          volume_type = "gp2"
       }

    tags = {
      Name = "spot-ssm-example-instance"
    }
  }

}
