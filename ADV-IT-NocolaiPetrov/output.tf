

output "aws_security_group-bastion-id" {
  value = aws_security_group.bastion.id
}

output "ami_id" {
  value       = data.aws_ami.latest_Amazon_linux.id
  description = "AMI ID of the Bastion"
}

output "launch_config_id" {
  value       = aws_launch_configuration.bastion.id
  description = "Launch configuration ID of the Bastion"
}

output "auto_scaling_group_id" {
  value       = aws_autoscaling_group.bastion.id
  description = "Auto scaling group id of the Bastion"
}

output "bastion_role_arn" {
  value       = "${aws_iam_role.bastion_iam_role.arn}"
  description = "Bastion Host's IAM role ARN"
}

output "bastion_instance_profile_arn" {
  value       = "${aws_iam_instance_profile.bastion_instance_profile.arn}"
  description = "Bastion Host's EC2 instance profile ARN"
}

output "bastion_instance_profile_name" {
  value       = "${aws_iam_instance_profile.bastion_instance_profile.name}"
  description = "Bastion Host's EC2 instance profile name"
}

output "IMPORTANT_INFO_______For_SmokeJumpers_____Please_use_this_Bastion_host_IP" {
  value       = aws_eip.RabbitHole.public_ip
  description = "Bastion_instance_public_IP"
}
