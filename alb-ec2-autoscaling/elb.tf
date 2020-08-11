resource "aws_alb" "alb" {
  name            = "example-alb"
  security_groups = [aws_security_group.web-instance-sg.id]
  subnets = [
    aws_subnet.public_a.id, aws_subnet.public_c.id
  ]
  internal                   = false
  enable_deletion_protection = false

  access_logs {
    bucket = aws_s3_bucket.alb_log.bucket
  }
}

resource "aws_alb_target_group" "alb" {
  name        = "alb-example-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.example-vpc.id
  target_type = "instance"

  health_check {
    interval            = 60
    path                = "/"
    protocol            = "HTTP"
    timeout             = 20
    unhealthy_threshold = 4
    matcher             = 200
  }
}


resource "aws_alb_listener" "alb_443" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = var.certificate_arn

  default_action {
    target_group_arn = aws_alb_target_group.alb.arn
    type             = "forward"
  }
}

resource "aws_alb_listener" "alb" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.alb.arn
    type             = "forward"
  }
}

output "alb" {
  value = {
    dns_name         = aws_alb.alb.dns_name
    arn              = aws_alb.alb.arn
    target_group_arn = aws_alb_target_group.alb.arn
  }
}

