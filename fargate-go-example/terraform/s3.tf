
resource "aws_s3_bucket" "alb_log" {
  bucket = "fargate-go-example-alb-log"
  acl    = "private"
  policy = data.aws_iam_policy_document.alb_log.json

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket_public_access_block" "alb_log" {
  bucket                  = aws_s3_bucket.alb_log.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
