# settings for using SSM and spot fleet
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com", "spotfleet.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "role" {
  name               = "ec2_assumerole"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy" "systems_manager" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "role-policy-attachment" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/service-role/AmazonEC2SpotFleetTaggingRole"
  ])

  role       = aws_iam_role.role.name
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "systems_manager" {
  name = "ssm-spot-profile"
  role = aws_iam_role.role.name
}
