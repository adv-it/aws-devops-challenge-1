/*
High Availability Host on AWS (Terraform)
Vlad Samchuk (email: vsamchuk1@gmail.com)
v0.1
*/
provider "aws" {
  region = var.region
}

resource "aws_security_group" "bastion-server" {
  name          = "SSH security group"
  vpc_id        = var.vpc
  description   = "Security Group for Bastion server"
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
    Name        = "SSH security group"
  }
}

data "template_file" "user_data" {
  template           = file("user-data.tpl")
  vars = {
    static_public_ip = aws_eip.bastion-ip.public_ip
    region_name      = var.region
  }
}

resource "aws_eip" "bastion-ip" {
  vpc    = true
  tags = {
    Name = "BastionIP"
  }
}

resource "aws_iam_role" "bastion-role" {
  name               = "bastion-role"
  assume_role_policy = file("role-policy.json")
}

resource "aws_iam_role_policy" "bastion-policy" {
  name   = "bastion-policy"
  role   = aws_iam_role.bastion-role.id
  policy = file("iam-policy.json")
}

resource "aws_iam_instance_profile" "bastion-profile" {
  name = "bastion-profile"
  role = aws_iam_role.bastion-role.name
}

resource "aws_launch_configuration" "bastion-server" {
  image_id                    = "ami-00068cd7555f543d5" 
  instance_type               = var.instance_type
  associate_public_ip_address = true
  key_name                    = var.ssh_key_pair
  security_groups             = [aws_security_group.bastion-server.id]
  iam_instance_profile        = aws_iam_instance_profile.bastion-profile.name
  name                        = "lc-bastion"
  user_data                   = data.template_file.user_data.rendered
}

resource "aws_autoscaling_group" "bastion-server" {
  vpc_zone_identifier  = var.subnets
  desired_capacity     = 1
  max_size             = 1
  min_size             = 1
  name                 = "asg-bastion"
  launch_configuration = aws_launch_configuration.bastion-server.name 
  tags = [
    {
      key                 = "Name",
      value               = "Bastion Host",
      propagate_at_launch = true
    }
  ]
}
