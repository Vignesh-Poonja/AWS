# AWS VPC with Private Subnets and NAT

## Overview
This project demonstrates how to create a **VPC with private subnets** and deploy servers in a production environment. The architecture includes:
- **Two Availability Zones** for high availability.
- **Auto Scaling group and Application Load Balancer (ALB)** to manage traffic.
- **Private subnets** for additional security.
- **NAT gateways** in each Availability Zone to allow outbound internet access for private instances.
- **VPC endpoints** for accessing Amazon S3 without using the internet.

For reference, see the AWS documentation: [VPC with servers in private subnets and NAT](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-example-private-subnets-nat.html).

---

## Architecture Diagram

![image](https://github.com/user-attachments/assets/fa2dfee4-89e2-4bad-9db4-b0a87aaba3b5)


---

## Steps to Set Up the VPC

### 1️⃣ Create the VPC
1. Open the **Amazon VPC Console**: [AWS VPC Console](https://console.aws.amazon.com/vpc/).
2. Click **Create VPC** and select **VPC and more**.
3. Configure the VPC:
   - Name: `aws-prod-example`
   - IPv4 CIDR Block: Keep default or enter your custom CIDR.
   - IPv6 CIDR Block: Select if your application requires IPv6.
4. Configure subnets:
   - Number of Availability Zones: `2`
   - Number of Public Subnets: `2`
   - Number of Private Subnets: `2`
   - NAT Gateways: `1 per AZ` (For high availability)
5. Create the VPC.

![image](https://github.com/user-attachments/assets/bfd5e9e3-2541-434d-8cfb-5938f5923005)

6. Create Autoscalling group:



---

### 2️⃣ Deploy Your Application
1. **Create a Bastion Host** for secure SSH access.
 - Copy the `.pem` key file to the bastion host:
  
For Ubuntu/Linux/MacOs:
```sh
scp -i "path/to/key.pem" path/to/file ubuntu@<Bastion-Host-IP>:/home/ubuntu/
```
For Windows:
```sh
scp -i "path\\to\\key.pem" "path\\to\\file" ubuntu@<Bastion-Host-IP>:/home/ubuntu/
```
![image](https://github.com/user-attachments/assets/a8706511-5af7-490c-aa90-b2bc3a0de7f0)

- Set file permissions:
  ```sh
  chmod 400 key.pem
  ```
- SSH into an instance using its **private IP**:
  ```sh
  ssh -i key.pem ubuntu@<Private-IP>
  ```
![image](https://github.com/user-attachments/assets/df7b1e6e-a777-4c6b-9cc4-69dc4245d9fe)



2. **Create an Auto Scaling Group** to manage EC2 instances across subnets.

![image](https://github.com/user-attachments/assets/23e653a1-5b64-4b74-9e82-103471563948)

Create launch template:

![image](https://github.com/user-attachments/assets/cbb335ae-2f3e-4450-9752-c7fd00c954f8)

Provide the Instance type:

![image](https://github.com/user-attachments/assets/40f5a5b1-8075-42ae-9b33-b97c97cc3075)

![image](https://github.com/user-attachments/assets/8f6c7224-2cfb-47ab-9e1e-61713ab72bc5)

Edit Inbound security group rules:

![image](https://github.com/user-attachments/assets/e6bfa98f-88c3-479c-ba7f-fabcd2423912)

Provide VPC, Availability zones and subnets details:

![image](https://github.com/user-attachments/assets/209828ff-644b-467a-a669-b8e637a26911)

![image](https://github.com/user-attachments/assets/f8d0a31a-df18-44ce-a532-a79f280a083a)

Configure Group sizing and Scaling:

![image](https://github.com/user-attachments/assets/3e625fe7-b67a-408b-96fb-21eaad8baf0b)

Verify the newly created Auto Scaling Group:

![image](https://github.com/user-attachments/assets/474f4e60-9d3f-4ea1-958a-0c3b73960d5b)

Check the Newly created instances:

![image](https://github.com/user-attachments/assets/37f98317-37da-43ed-b751-c262d89b1114)


4. **Create a Load Balancer**:
![image](https://github.com/user-attachments/assets/7cdfb84a-5687-4a70-9930-03f3d9283c53)
![image](https://github.com/user-attachments/assets/499799eb-6cbe-407e-a1fb-71500c34bfa6)
![image](https://github.com/user-attachments/assets/7cadf9e5-5295-40c9-a47f-5f85602a4c8d)
![image](https://github.com/user-attachments/assets/ea9d66c3-bd6c-4be9-976c-011b072ec5af)

- Define a **target group**.

select the Instances
![image](https://github.com/user-attachments/assets/43c89e63-c47c-4749-8666-a3b058127569)

Click on “include as below”  Create target group
![image](https://github.com/user-attachments/assets/4f91e18b-8148-4d40-a907-ba197f2ef142)
![image](https://github.com/user-attachments/assets/40d467d9-e7ec-4839-aeed-945f04ebd1af)

- Keep the port as `80` for HTTP traffic.
![image](https://github.com/user-attachments/assets/9cf42ff7-29ab-477f-b372-9f36c0081013)

- Attach the load balancer to your Auto Scaling Group.
  
---

### 3️⃣ Test Your Configuration
- Validate that your instances are launching successfully.
- Ensure the **ALB** is distributing traffic correctly.
- Use AWS **Reachability Analyzer** to troubleshoot any network issues.

![image](https://github.com/user-attachments/assets/5ba29fce-e445-48a6-a3af-b78c63771606)


---

### 4️⃣ Clean Up Resources
If you are done with this setup, **delete the resources**:
1. Terminate the instances and delete the Auto Scaling Group.
2. Delete the NAT Gateways.
3. Delete the Load Balancer.
4. Finally, delete the VPC.

---

## Notes
✅ **Why Port 80 Works**
- Standard HTTP port used by browsers.
- ALB allows traffic on **port 80 by default**.
- Security group is configured to allow HTTP traffic.

❌ **Why Port 8000 Doesn't Work**
- ALB is optimized for web traffic (port **80/443**).
- It might not handle requests on **non-standard ports like 8000**.

---

## Conclusion
This setup provides a **secure, highly available VPC** for production workloads. With **Auto Scaling, ALB, and NAT Gateways**, it ensures smooth deployment and internet access for private instances. 🚀


