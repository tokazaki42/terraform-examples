resource "aws_launch_configuration" "autoscaling_example" {
  name_prefix                 = "autoscaling_example-"
  image_id                    = var.instance_ami
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.ssh-key.key_name
  security_groups             = [aws_security_group.web-instance-sg.id]
  user_data                   = file("./userdata.sh")
  iam_instance_profile        = aws_iam_instance_profile.systems_manager.name
  associate_public_ip_address = true
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "autoscaling_example" {
  name                      = "autoscaling_example"
  max_size                  = 2
  min_size                  = 2
  desired_capacity          = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.autoscaling_example.id}"
  vpc_zone_identifier       = [aws_subnet.public_a.id, aws_subnet.public_c.id]
  target_group_arns         = [aws_alb_target_group.alb.arn]

}

resource "aws_autoscaling_schedule" "weekdays-shutdown" {
  scheduled_action_name  = "weekdays-shutdown"
  min_size               = 0
  max_size               = 0
  desired_capacity       = 0
  recurrence             = "00 12 * * MON-FRI"
  autoscaling_group_name = "${aws_autoscaling_group.autoscaling_example.name}"
}

resource "aws_autoscaling_schedule" "weekdays-startup" {
  scheduled_action_name  = "weekdays-startup"
  min_size               = 2
  max_size               = 2
  desired_capacity       = 2
  recurrence             = "00 19 * * MON-FRI"
  autoscaling_group_name = "${aws_autoscaling_group.autoscaling_example.name}"
}

resource "aws_key_pair" "ssh-key" {
  key_name   = "example-operation-pubkey"
  public_key = file(var.pubkey_file_path)
}
