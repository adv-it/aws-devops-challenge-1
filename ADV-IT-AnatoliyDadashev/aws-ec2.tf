#Author: Anatoliy Dadashev
#e-mail: ceasar221@gmail.com
#Resources to create EC2 instance from ASG using launch configuration with EIP
resource "aws_launch_configuration" "bastion_lc" {
  associate_public_ip_address = true
  image_id                    = "ami-010fae13a16763bb4"
  iam_instance_profile        = "${aws_iam_instance_profile.bastion-node.name}"
  instance_type               = "${var.instance_type}"
  name_prefix                 = "bastion"
  security_groups             = ["${aws_security_group.bastion.id}"]
  key_name                    = "${var.key_pair_name}"

  lifecycle {
    create_before_destroy = true
  }
  user_data = templatefile("user_data.sh", {
    eip    = "${aws_eip.bastion.id}",
    region = "${var.region}"
  })
}

resource "aws_autoscaling_group" "bastion_asg" {
  desired_capacity     = "1"
  launch_configuration = "${aws_launch_configuration.bastion_lc.name}"
  max_size             = "1"
  min_size             = "1"
  default_cooldown     = "0"
  name                 = "${var.env_name}"
  vpc_zone_identifier  = flatten(["${data.aws_subnet.subnets.*.id}"])
  tags = "${concat(var.tags_ec2,
    list(
      map("key", "Name",
        "value", "${var.env_name}",
      "propagate_at_launch", "true")
  ))}"
}
