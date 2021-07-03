data "template_file" "s3_ec2_policy" {
  template = file("scripts/ec2-policy.json")
  vars = {
    s3_bucket_arn = "arn:aws:s3:::${var.s3_bucket_http_name}/*"
  }
}

resource "aws_iam_role_policy" "ec2_policy" {
  name = "ec2_policy"
  role = aws_iam_role.ec2_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = data.template_file.s3_ec2_policy.rendered
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = file("scripts/ec2_assume_role.json")
}

# Attach role to EC2

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_role.name
}
