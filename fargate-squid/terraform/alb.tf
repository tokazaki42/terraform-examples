// albを作成。
resource "aws_alb" "alb" {
  name                       = "squid-proxy-example"
  security_groups            = [aws_security_group.instance-sg.id]
  subnets = [
    "${aws_subnet.public_a.id}",
    "${aws_subnet.public_c.id}",
  ]
  internal                   = true
  enable_deletion_protection = false

  access_logs {
    bucket = aws_s3_bucket.alb_log.bucket
  }
}

// albのターゲットグループ
resource "aws_alb_target_group" "alb" {
  name     = "rails-example-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.example-vpc.id
  target_type = "ip"

  health_check {
    interval            = 60
    path                = "/"
    // NOTE: defaultはtraffic-port
    port                = 8080
    protocol            = "HTTP"
    timeout             = 20
    unhealthy_threshold = 4
    matcher             = 400
  }
}



resource "aws_alb_listener" "alb" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.alb.arn}"
    type             = "forward"
  }
}


output "alb" {
  value = {
    dns_name         = "${aws_alb.alb.dns_name}"
    arn              = "${aws_alb.alb.arn}"
    target_group_arn = "${aws_alb_target_group.alb.arn}"
  }
}
