#!/bin/bash
INSTANCE_ID=`curl http://169.254.169.254/latest/meta-data/instance-id`
REGION_ID=`curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep -oP '\"region\"[[:space:]]*:[[:space:]]*\"\K[^\"]+'`
ALLOCATION_ID=$(aws ec2 describe-addresses --output text --region $REGION_ID --query "Addresses[?AssociationId==null].AllocationId" | awk '{print $1}')
aws ec2 associate-address --instance-id $INSTANCE_ID --region $REGION_ID --allocation-id $ALLOCATION_ID