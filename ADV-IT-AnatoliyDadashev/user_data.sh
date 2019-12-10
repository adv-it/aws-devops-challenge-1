#!/bin/bash
instance_id=`curl -s http://169.254.169.254/latest/meta-data/instance-id`
aws ec2 associate-address --instance-id $instance_id --allocation-id ${eip} --region ${region} --allow-reassociation
