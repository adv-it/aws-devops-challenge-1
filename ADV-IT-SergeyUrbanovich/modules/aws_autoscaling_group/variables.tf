variable "baseName"{
}

variable "imageID"{
}

variable "region"{
}

variable "awsEipID"{
}

variable "instanceType"{
}

variable "iamInstanceProfileName"{
}

variable "keyName"{
}

variable "vpcZoneIdentifier"{
    type = list(string)
}

variable "vpcSecurityGroupIds"{
    type = list(string)
}

variable "vpcID" {
}
variable "tags" { 
    type = map(string)
}
