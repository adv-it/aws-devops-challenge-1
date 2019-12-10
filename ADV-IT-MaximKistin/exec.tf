provider "aws" {
  region = var.region
}

locals {
  label = "devops_001"
  owner = "Maksim"
}

resource "aws_security_group" "SG_SSH_001" {
  name        = "sg_ssh_001"
  description = "SG SSH 001"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Label = local.label
    Owner = local.owner
  }
}

resource "aws_eip" "EIP_001" {
  vpc = true

  tags = {
    Name  = "eIP_to_ec2_001"
    Label = local.label
    Owner = local.owner
  }
}

resource "aws_iam_role_policy" "ec2_policy" {
  name   = "ec2_policy_001"
  role   = "${aws_iam_role.ec2_eip_allow_role.id}"
  policy = "${file("ec2_policy.json")}"
}

resource "aws_iam_role" "ec2_eip_allow_role" {
  name               = "ec2_role_001"
  assume_role_policy = "${file("ec2_assume_policy.json")}"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile_001"
  role = "${aws_iam_role.ec2_eip_allow_role.name}"
}

data "aws_ami" "linux_ami" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }

  owners = ["amazon"]
}

resource "aws_launch_configuration" "ec2_lc" {
  name                 = "ec2_lc_001"
  image_id             = "${data.aws_ami.linux_ami.id}"
  instance_type        = var.instance_Type
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  security_groups      = [aws_security_group.SG_SSH_001.id]
  user_data            = "${file("user_data.sh")}"
  enable_monitoring    = false
  key_name             = "${var.key_pair_name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ec2_asg" {
  name                 = "ec2_asg_001"
  launch_configuration = "${aws_launch_configuration.ec2_lc.name}"
  #availability_zones       = "${var.availability_Zones_Arr}"
  vpc_zone_identifier       = "${var.subnet_ids}"
  min_size                  = 1
  max_size                  = 1
  desired_capacity          = 1
  health_check_grace_period = 60
  tags = [
    {
      key                 = "Name"
      value               = "Bastion-Host_001"
      propagate_at_launch = true
    },
    {
      key                 = "Owner"
      value               = local.owner
      propagate_at_launch = true
    },
    {
      key                 = "Label"
      value               = local.label
      propagate_at_launch = true
    }
  ]
}
