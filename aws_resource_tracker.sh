#!/bin/bash

# Author: VK
# Date: 03/01/2025
# Version: v1

# This script will report AWS resource usage
# *************************************************

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "jq could not be found. Please install jq to run this script."
    exit 1
fi

# List S3 Buckets
echo "Print list of S3 buckets"
aws s3 ls >> resourceTracker.txt
echo "************************" >> resourceTracker.txt

# List EC2 Instances
echo "Print list of EC2 instances"
aws ec2 describe-instances | jq '.Reservations[].Instances[].InstanceId' >> resourceTracker.txt
echo "************************" >> resourceTracker.txt

# List Lambda Functions
echo "Print list of Lambda functions"
aws lambda list-functions >> resourceTracker.txt
echo "************************" >> resourceTracker.txt

# List IAM users
echo "Print list of IAM Users"
aws iam list-users >> resourceTracker.txt
echo "************************" >> resourceTracker.txt

# Add completion message with date
echo "AWS resource tracking has been completed for $(date)" >> resourceTracker.txt
