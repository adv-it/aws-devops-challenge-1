
terraform {
  required_version = "~>0.12"
}

provider "aws" {
  region = var.region
}

# key pair to login to EC2
resource "aws_key_pair" "jumpkey" {
  key_name   = "jump-key"
  public_key = file(var.private_key_path)
}

# Elastic IP address (EIP)
resource "aws_eip" "RabbitHole" {
  vpc = true
  tags = merge(var.common_tags, {
    Name = "Elastic IP for ${var.common_tags["Environment"]} Bastion server"
  })
}

# Security Group (SG)
resource "aws_security_group" "bastion" {
  name        = "Bastion_Security_group"
  description = "Security Group for Bastion"
  vpc_id      = var.vpc-id
  tags = merge(var.common_tags, {
    Name = "Security Group for ${var.common_tags["Environment"]} Bastion server"
  })

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "22"
    protocol    = "tcp"
    to_port     = "22"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Auto Scalig Group (ASG)
resource "aws_autoscaling_group" "bastion" {
  name                 = "ASG-${aws_launch_configuration.bastion.name}"
  launch_configuration = aws_launch_configuration.bastion.name
  min_size             = 1
  max_size             = 1
  min_elb_capacity     = 1
  health_check_type    = "ELB"
  vpc_zone_identifier  = var.az_subnets

  dynamic "tag" {
    for_each = {
      Name : "Bastion Server in ASG-${aws_launch_configuration.bastion.name}"
      Maintainer : "Nicolai Petrov"
      Project : "AWS DevOps Challenge-1"
      Environment : "Dev"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

# Launch configuration (LC)
resource "aws_launch_configuration" "bastion" {
  name_prefix          = "bastion-lc-"
  image_id             = data.aws_ami.latest_Amazon_linux.id
  instance_type        = var.instance_type
  key_name             = aws_key_pair.jumpkey.key_name
  iam_instance_profile = aws_iam_instance_profile.bastion_instance_profile.name
  security_groups      = [aws_security_group.bastion.id]
  user_data            = data.template_file.bastion_user_data.rendered
}

data "aws_ami" "latest_Amazon_linux" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }
}

data "template_file" "bastion_user_data" {
  template = file("${path.module}/user_data.sh")
  vars = {
    REGION = var.region,
    EIP_ID = aws_eip.RabbitHole.id
  }
}

# Identity and Access Management (IAM)
resource "aws_iam_role" "bastion_iam_role" {
  name = "bastion_iam_role"
  tags = merge(var.common_tags, {
    Name = "IAM role for ${var.common_tags["Environment"]} Bastion server"
  })

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "bastion_iam_policy" {
  name = "bastion_iam_policy"
  path = "/"
  description = "Bastion IAM Policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "ec2:AssociateAddress"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "bastion_attach_iam_policy" {
  role       = aws_iam_role.bastion_iam_role.name
  policy_arn = aws_iam_policy.bastion_iam_policy.arn
}

resource "aws_iam_instance_profile" "bastion_instance_profile" {
  name = "bastion_instance_profile"
  role = aws_iam_role.bastion_iam_role.name
}
