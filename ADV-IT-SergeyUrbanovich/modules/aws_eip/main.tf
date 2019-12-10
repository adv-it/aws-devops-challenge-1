################################
# Aauthor:  Urbanovich Sergei  #
# E-mail:   urb.s@tut.by       #
################################

resource "aws_eip" "eip" {
  vpc = true

  tags = var.tags
}