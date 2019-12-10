################################
# Aauthor:  Urbanovich Sergei  #
# E-mail:   urb.s@tut.by       #
################################

resource "aws_iam_role" "role" {
  name = "${var.baseName}-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = var.tags
}

/* An instance profile is a container for an IAM role 
that you can use to pass role information to an EC2 instance 
when the instance starts. */

resource "aws_iam_instance_profile" "profile" {
  name = "${var.baseName}-iam_instance_profile"
  role = aws_iam_role.role.name
}

resource "aws_iam_policy" "policy" {
  name = "${var.baseName}-policy"

  description = "Custom policy for ${var.baseName}"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowEIPAttachment",
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "ec2:AssociateAddress",
        "ec2:DisassociateAddress"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "attach" {
  name       = "${var.baseName}-attachment"
  roles      = [aws_iam_role.role.name]
  policy_arn = aws_iam_policy.policy.arn
}

