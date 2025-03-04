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


![image](https://github.com/user-attachments/assets/b1c96018-52fc-4a45-b67a-29625017029f)


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

![image](https://github.com/user-attachments/assets/fd4cc2bf-0e79-49fa-a952-d275cb82774b)

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
![image](https://github.com/user-attachments/assets/5cc5718b-defb-429d-b70e-fa303ee3590e)


- Set file permissions:
  ```sh
  chmod 400 key.pem
  ```
- SSH into an instance using its **private IP**:
  ```sh
  ssh -i key.pem ubuntu@<Private-IP>
  ```
![image](https://github.com/user-attachments/assets/711a1299-5faa-442b-bccd-afaa553cc175)




2. **Create an Auto Scaling Group** to manage EC2 instances across subnets.

![image](https://github.com/user-attachments/assets/d35d588b-e60e-4a66-b924-d51b166d7a38)


Create launch template:

![image](https://github.com/user-attachments/assets/10acb8ac-e71d-4478-8c07-3e3d97e98a0e)


Provide the Instance type:

![image](https://github.com/user-attachments/assets/b2a41acc-feb1-4e8c-bcd6-22f46d4e998c)
![image](https://github.com/user-attachments/assets/844a29b7-660f-477d-a898-0bb0b9347c68)


Edit Inbound security group rules:

![image](https://github.com/user-attachments/assets/82569848-2768-46e1-aaaf-cbf82483b547)


Provide VPC, Availability zones and subnets details:

![image](https://github.com/user-attachments/assets/b2927f66-3e20-4b43-a970-e47fb66e25db)
![image](https://github.com/user-attachments/assets/66aec5bc-52b2-421e-9c93-73472524f971)


Configure Group sizing and Scaling:

![image](https://github.com/user-attachments/assets/4d12f266-a60a-4f84-a9b1-55928e48a34e)


Verify the newly created Auto Scaling Group:

![image](https://github.com/user-attachments/assets/cb42b08e-7535-4577-8643-211081936f0c)


Check the Newly created instances:

![image](https://github.com/user-attachments/assets/035b9402-af54-4a9e-9089-6bc82fcb54c7)



4. **Create a Load Balancer**:

![image](https://github.com/user-attachments/assets/d9797bc3-e81e-474d-8c6a-24cff27c819d)
![image](https://github.com/user-attachments/assets/e0af510e-579d-4125-9ab6-b3e0a2a3e9f3)
![image](https://github.com/user-attachments/assets/cb33c026-920f-461e-a05e-764edca77fe7)

- Define a **target group**.

![image](https://github.com/user-attachments/assets/b7d29d5e-d667-45bf-9090-7328a1e6695e)

select the Instances

![image](https://github.com/user-attachments/assets/cee689b4-ba13-4083-b3d1-1ffe3a2d950d)


Click on “include as below”  Create target group

![image](https://github.com/user-attachments/assets/841434a8-f219-4713-8d4f-be127e1959bd)
![image](https://github.com/user-attachments/assets/fa168c3f-366e-4cb9-a694-20cfb9bdb02a)


- Keep the port as `80` for HTTP traffic.

![image](https://github.com/user-attachments/assets/690f99b1-2029-47a5-8847-6f33dd9db772)


- Attach the load balancer to your Auto Scaling Group.
  
---

### 3️⃣ Test Your Configuration
- Validate that your instances are launching successfully.
- Ensure the **ALB** is distributing traffic correctly.
- Use AWS **Reachability Analyzer** to troubleshoot any network issues.

![image](https://github.com/user-attachments/assets/082e823c-08a0-4136-b216-1177b26e82d3)



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


