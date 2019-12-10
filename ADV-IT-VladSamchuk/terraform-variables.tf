variable "region" {
  type = string
  description = "Region Name"
#  default = "us-east-1"
}

variable "ssh_key_pair" {
  type = string
  description = "SSH key"
#  default = "tux"
}

variable "instance_type" {
  type = string
  description = "Instance Type"
#  default = "t3.nano"
}

variable "subnets" {
  type = list
  description = "Subnets"
#  default = ["subnet-8272efbd", "subnet-810aee8e", "subnet-ef11568b", "subnet-5fe8af14"]
}

variable "vpc" {
  type = string
  description = "VPC ID"
#  default = "vpc-e1b3e499"
}