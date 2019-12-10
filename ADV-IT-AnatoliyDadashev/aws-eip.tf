#Author: Anatoliy Dadashev
#e-mail: ceasar221@gmail.com
#Elastic IP for EC2
resource "aws_eip" "bastion" {
  vpc = true
  tags = "${merge(map("Name", "${var.env_name} EIP"),
  var.tags_all)}"
}
