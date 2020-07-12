data "aws_elb_service_account" "alb_log" {
}

data "aws_iam_policy_document" "alb_log" {
  statement {
    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::rails-example-alb-log/*",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${data.aws_elb_service_account.alb_log.id}:root",
      ]
    }
  }
}