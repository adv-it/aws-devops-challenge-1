
AWS DevOps Challenge-1 ( BASTION )
====================
WARNING:
You *probably* don't want to use this code directly. Please read ALL instructions first.

"BASTION"
---------
Goal:  
    This project aims to deploy simplest/lazy High Available (HA) Jump-host A.K.A 'RabbitHole' to operate and maintain your private AWS infrastructure.

Benefits:
    Basion Host will be allways up ( some downtime acceptable).
    In case this host will crash, another host has to auto-started (about 5-10 min) 


Architecture
------------

    You should have the VPC and public subnets (2 or more) in desired region. 
    This Infrastructure as code (IaC) is responsible for creating the Auto Scalig Group (ASG) and auto lunch BASTION host with assigned security groups (SG), copied ssh-key for passwordless login via the Elastic IP (EIP). 

The idea is that you can use same IP for SSH login.


### Prerequisites

NOTE: Prior to running Please read note bellow. 

You should have:
- SSH keys or generate new one.  
- Know Region name.
- Know VPS-id in desired region.
- Know minimum 2 Subnet-id's in different avaliability zones (AZ) in desired VPS.
- Choose elastic cloud compute (EC2) instance type.

And Edit terraform.tfvars

-------------------------
# region example.
region = "us-east-1"

# VPC ID example.
vpc-id = "vpc-0fe04eda7f3992a9a"

# AZ subnets example. Note minimum 2, maximum 6, depends on the region.     
az_subnets = ["subnet-02d1d2a803b2430fb", "subnet-037a7ea58280e0b8d"]

# Instance type example.
instance_type = "t2.micro"

# Please provide path to your ssh-key 
# private_key_path = " path/key.pem "
private_key_path = "~/.ssh/id_rsa.pub"
--------------------------------------

**NOTE**: You **must** being using at least terraform 0.12 + 


### Running terraform

**WARNING**: You **must** understand only you responsible to any AWS Charges.
Run that IaC can sometimes result in unexpected charges.
Read Carefully and DO NOT use it if you are not sure what are you doing.

More details:
https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/checklistforunwantedcharges.html


### Set AWS Credentials in Windows PowerShell:

```
$env:AWS_ACCESS_KEY_ID="xxxxxxxxxxxxxxxxx"
$env:AWS_SECRET_ACCESS_KEY="yyyyyyyyyyyyyyyyyyyyyyyyyyyy"
```

### Set AWS Credentials in Linux Shell:
```
export AWS_ACCESS_KEY_ID="xxxxxxxxxxxxxxxxx"
export AWS_SECRET_ACCESS_KEY="yyyyyyyyyyyyyyyyyyyyyyyyyyyy"
```

### Terraform Commands
```
terraform init
terraform plan
terraform apply

terraform output
terraform destroy
```


```
terraform init
terraform plan 
terraform apply 
```


### Smoke Jumpers TIPS

Finally you should receive similar message. 
~~~
Outputs:

IMPORTANT_INFO_______For_SmokeJumpers_____Please_use_this_Bastion_host_IP = 3.233.44.249
--- ommited ---
~~~

count to Ten and jump on it - 3.233.44.249

```
ssh ec2-user@3.233.44.249
```

in case of Bastion host restrted, you will reseived warning :
~~~
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--- ommited ---
~~~

To ingnore this Strict Host Key Checking

```
ssh -o StrictHostKeyChecking=no ec2-user@3.233.44.249
```

---------
Written by Nicolai Petrov (https://pitonic.github.io/)
