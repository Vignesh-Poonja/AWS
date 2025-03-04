# AWS Resource Tracker

## Overview
The **AWS Resource Tracker** is a Bash script that collects and logs details about AWS resources, including:
- S3 Buckets
- EC2 Instances
- Lambda Functions
- IAM Users  

The script outputs the data to `resourceTracker.txt` for easy reference.

## Author
- **Name:** VK  
- **Date:** 03/01/2025  
- **Version:** v1  

## Features
✔ Lists all **S3 buckets**.  
✔ Retrieves **EC2 instance IDs**.  
✔ Displays details of **Lambda functions**.  
✔ Lists all **IAM users**.  
✔ Logs the output to `resourceTracker.txt`.  
✔ Ensures `jq` is installed for JSON parsing.

---

## Prerequisites
Before running the script, ensure you have the following:

1. **AWS CLI Installed & Configured**  
   - Install AWS CLI:  
     ```sh
     curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
     sudo installer -pkg AWSCLIV2.pkg -target /
     ```
   - Configure AWS credentials:  
     ```sh
     aws configure
     ```

2. **jq Installed** (Required for parsing JSON output)
   - **Ubuntu/Debian**:  
     ```sh
     sudo apt-get install jq
     ```
   - **macOS (Homebrew)**:  
     ```sh
     brew install jq
     ```
   - **Windows (Chocolatey)**:  
     ```sh
     choco install jq
     ```

---

## **How to Run the Script**
Follow these steps to execute the script:

### **1. Download or Clone the Repository**
```sh
git clone https://github.com/your-username/.git
cd Resource Tracker
```

2. Make the Script Executable

```sh
chmod +x aws_resource_tracker.sh
```
3. Run the Script
```sh
./aws_resource_tracker.sh
```
4. View the Output
```sh
The output is saved in resourceTracker.txt:
```

```sh
cat resourceTracker.txt
```

Expected Output:

Print list of S3 buckets
************************
bucket-name-1
bucket-name-2

Print list of EC2 instances
************************
"i-0abcd1234efgh5678"
"i-09zyx9876wvu5432"

Print list of Lambda functions
************************
{
    "Functions": [...]
}

Print list of IAM Users
************************
{
    "Users": [...]
}

AWS resource tracking has been completed for Tue Mar 1 10:00:00 UTC 2025


#Customization

Modify the script to track RDS, VPCs, Security Groups, etc.
Redirect logs to AWS CloudWatch Logs for centralized monitoring.
Troubleshooting
If you encounter errors:

Ensure AWS CLI is installed and configured (aws configure).
Check if you have the necessary AWS IAM permissions.
