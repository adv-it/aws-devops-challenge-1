#Author: Anatoliy Dadashev
#e-mail: ceasar221@gmail.com
#Input variables for resources
variable "instance_type" {
  description = "Instance type"
  default     = "t2.micro"
  type        = "string"
}

variable "key_pair_name" {
  description = "Name of EC2 SSH key pair"
  default     = "bastion"
  type        = "string"
}

variable "region" {
  description = "Region for Bastion node"
  default     = "eu-central-1"
  type        = "string"
}

variable "vpc_id" {
  description = "ID of VPC"
  default     = "vpc-85e20eef"
  type        = "string"
}

variable "env_name" {
  description = "Name of EC2 instance"
  default     = "Bastion"
  type        = "string"
}

variable "tags_ec2" {
  description = "List of maps of tags that will be applied to the Auto Scaling group for Bastion node.  Keys and values are case-sensitive"
  default = [
    {
      "key"                 = "Application",
      "value"               = "AWS DevOps Challenge",
      "propagate_at_launch" = true
    },
    {
      "key"                 = "Terraformed",
      "value"               = "true",
      "propagate_at_launch" = true
    }
  ]
  type = "list"
}

variable "tags_all" {
  description = "Map of specific tags that will be added to the defaults (e.g. Name) for all AWS resources.  Keys and values are case-sensitive"
  default = {
    Application = "AWS DevOps Challenge"
    Terraformed = "true"
  }
  type = "map"
}
