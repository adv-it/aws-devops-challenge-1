variable "region" {
  type        = string
  description = "Please input region"
}

variable "instance_Type" {
  type        = string
  description = "Please input instance type"
}

variable "vpc_id" {
  type        = string
  description = "Please input vpc id"
}

/*variable "availability_Zones_Arr" {
  type        = list(string)
  description = "Please input availability zones for auto scaling group"
  default     = ["eu-west-3a", "eu-west-3b", "eu-west-3c"]
}*/

variable "subnet_ids" {
  type        = list(string)
  description = "Please input availability zones for auto scaling group"
}

variable "key_pair_name" {
  type        = string
  description = "Please input SSH key pair name"
}
