data "aws_iam_policy" "ssm_managed" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "default" {
  count = local.is_iam_instance_profile_set ? 0 : 1

  name = format("%s-instance-profile", var.name)
  role = local.iam_instance_role
}

resource "aws_iam_role" "default" {
  count              = local.is_iam_instance_profile_set ? 0 : 1
  name               = format("%s", var.name)
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role_ec2.json
}

resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  count = local.is_iam_instance_profile_set ? 0 : 1

  role       = aws_iam_role.default[count.index].id
  policy_arn = data.aws_iam_policy.ssm_managed.arn
}

data "aws_iam_policy_document" "assume_role_ec2" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_policy" "ec2_demo" {
  name        = format("%s-%sEC2DemoAccess", var.service, var.env)
  description = "Goldfire server policy to grant access for requred resources."

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PutParameter",
            "Effect": "Allow",
            "Action": [
              "ssm:PutParameter",
              "ssm:GetParameter"
            ],
            "Resource": [
              "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter${local.ssm_prefix}/*"
            ]
        },
        {
            "Sid": "S3",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "app_node_read" {
  policy_arn = aws_iam_policy.ec2_demo.arn
  role       = .ec2_instance_iam.iam_role_name
}