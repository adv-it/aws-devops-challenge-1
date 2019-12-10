variable "instance_parametrs" {
  type = map(string)

  default = {
    "ssh_keypair_name" = "myec2key" # <- be sure to use your own 'ssh_keypair_name'
    "image_id"         = "ami-010fae13a16763bb4"
    "instance_type"    = "t2.micro"
    "region"           = "eu-central-1"
  }
}

variable "vpc_id" {
  default = "vpc-0f1b21e2087a98e20" # <- be sure to use your own 'vpc_id'
}

variable "base_name" {
  default = "adv_it"
}

variable "subnets" { # <- be sure to use your own 'subnets'
  type = list(string)

  default = [
    "subnet-067656ff2ca4281e4",
    "subnet-06cf47e86424b7030",
    "subnet-082b82a15a6699b1e"
  ]
}

variable "common_tags" {
  type = map(string)

  default = {
    Owner   = "Siarhei_Urbanovich"
    Project = "adv_it_challange1"
  }
}