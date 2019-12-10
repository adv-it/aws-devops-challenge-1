################################
# Aauthor:  Urbanovich Sergei  #
# E-mail:   urb.s@tut.by       #
################################

resource "aws_security_group" "security_group" {

  name        = "${var.baseName}-security_group"
  description = "Custom security group for ${var.baseName}"
  vpc_id      = var.vpcID

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

  tags = var.tags

}