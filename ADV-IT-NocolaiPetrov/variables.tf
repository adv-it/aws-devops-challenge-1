# variables 
variable "region" {}

variable "vpc-id" {}

variable "az_subnets" {
  type    = list
  default = []
}

variable "instance_type" {}

variable "private_key_path" {}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default = {
    Maintainer : "Nicolai Petrov"
    Project : "AWS DevOps Challenge-1"
    Environment : "Dev"
  }
}