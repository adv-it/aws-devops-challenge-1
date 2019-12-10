#Author: Anatoliy Dadashev
#e-mail: ceasar221@gmail.com
resource "aws_security_group" "bastion" {
  name        = "Bastion Security Group"
  description = "Security group for EC2 instance with SSH only"

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

  tags = "${merge(map("Name", "${var.env_name} Security Group"),
  var.tags_all)}"

}
