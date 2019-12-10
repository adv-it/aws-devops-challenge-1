################################
# Aauthor:  Urbanovich Sergei  #
# E-mail:   urb.s@tut.by       #
################################

locals {
  instance-userdata = <<EOF
#cloud-config
runcmd:
  - aws ec2 associate-address --instance-id $(curl http://169.254.169.254/latest/meta-data/instance-id) --allocation-id ${var.awsEipID} --allow-reassociation --region ${var.region}
EOF
}

resource "aws_launch_template" "template" {

  name = "${var.baseName}-launch_template"

  image_id      = var.imageID
  instance_type = var.instanceType

  vpc_security_group_ids = var.vpcSecurityGroupIds

  iam_instance_profile {
    name = var.iamInstanceProfileName
  }

  key_name = var.keyName

  tag_specifications {
    resource_type = "instance"
    tags = var.tags
  }

  user_data = base64encode(local.instance-userdata)

}

resource "aws_autoscaling_group" "autoscaling" {
  name                = "${var.baseName}-autoscaling_group"
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"

  vpc_zone_identifier = var.vpcZoneIdentifier

  launch_template {
    id      = aws_launch_template.template.id
    version = "$Latest"
  }

}