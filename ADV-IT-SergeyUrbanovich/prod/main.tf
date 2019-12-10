################################
# Aauthor:  Urbanovich Sergei  #
# E-mail:   urb.s@tut.by       #
################################

# Configuring the AWS Provider
provider "aws" {
  version    = "~> 2.0"
  region     = var.instance_parametrs["region"]
  # access_key = ""
  # secret_key = ""
}

# Creating policy, role, instance_profile
module "aws_iam" {
  source = "../modules/aws_iam"

  baseName = var.base_name
  tags     = var.common_tags
}

# Creating 'Security Group' (allow ssh - port 22)
module "aws_security_group" {
  source = "../modules/aws_security_group"

  baseName = var.base_name
  vpcID    = var.vpc_id
  tags     = var.common_tags
}

# Creating 'Elastic IP'
module "aws_eip" {
  source = "../modules/aws_eip"
  
  tags = var.common_tags
}

# Creating 'Autoscaling Group' with 1 instance (Cheap High Availability)
module "aws_autoscaling_group" {
  source = "../modules/aws_autoscaling_group"

  imageID                = var.instance_parametrs["image_id"]
  instanceType           = var.instance_parametrs["instance_type"]
  keyName                = var.instance_parametrs["ssh_keypair_name"]
  region                 = var.instance_parametrs["region"]
  awsEipID               = module.aws_eip.eipID
  vpcSecurityGroupIds    = [module.aws_security_group.securityGroupID]
  iamInstanceProfileName = module.aws_iam.iamInstanceProfileName
  vpcZoneIdentifier      = var.subnets
  baseName               = var.base_name
  vpcID                  = var.vpc_id
  tags = var.common_tags
}