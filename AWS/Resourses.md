
## Step 1: Log in to AWS Console

- Go to https://console.aws.amazon.com
- Sign in with Username,Password,MFA.

## Step 2: Select Region

- Before creating resourses select your Region at top right corner.


## Step 3:Create Resouses in Dashboard 

### 1. VPC

A Virtual Private Cloud (VPC) is a virtual network dedicated to your AWS account. AWS provides a Default VPC for ease of use, but you can also create Custom VPCs for more control and customization.

![image](https://github.com/user-attachments/assets/a795c962-1031-4274-9b77-bbca814428a8)

#### Steps to Create a Custom VPC

- Go to VPC Console → Your VPCs → Create VPC

- Choose VPC only

   - Name: my-vpc

   - IPv4 CIDR block: 10.0.0.0/16

- Leave other settings default → Create VPC

 ### 2.Subnets

 Subsections inside your VPC.
 
#### Public Subnet

 - Name: public-subnet

 - CIDR block: 10.0.1.0/24

 - Availability Zone: us-east-1a (for example)

 - Enable Auto-assign public IP

#### Private Subnet

 - Name: private-subnet

 - CIDR block: 10.0.2.0/24

 - Availability Zone: same or different (e.g. us-east-1a)

 - Don't enable auto-assign public IP

### 3.Create Internet Gateway (IGW)
    Acts like a router that lets your VPC talk to the internet.

#### Steps in console

 - VPC Console → Internet Gateways → Create

   - Name: my-igw

   - Attach it to your VPC: my-vpc

### 4.Create Route Tables
It decides where network traffic should go.

#### Steps in console

#### Public Route Table

- Name: public-rt

- Associate with VPC: my-vpc

- Add route:

 - Destination: 0.0.0.0/0

 - Target: Internet Gateway

 - Associate this table with public-subnet

#### Private Route Table

- Name: private-rt

- Add route:

 - Destination: 0.0.0.0/0

 - Target: NAT Gateway (after you create it below)

 - Associate this with private-subnet

 ### 5. Create NAT Gateway

  Lets private subnets access the internet only for outbound traffic (e.g., updates), without being exposed.

#### Steps in console

- Elastic IPs → Allocate a new one 

- NAT Gateways → Create

  -  Subnet: Choose one public-subnet

  -  Elastic IP: select the one you allocated or allocate a new one.

-  After creation, go back to your **private route table** and add a route to 0.0.0.0/0 via **NAT Gateway**

### 6. Launch EC2 (App Server)
A virtual server to run your web/app/backend.

#### Steps in console 

- Go to EC2 Console → Launch Instance

- Name: app-server

- Application and OS Images : Ubuntu

- Instance type: t2.micro (Free Tier eligible)

- Key pair (login):

   - Create a new key pair or use an existing one
   - If creating new:
     - Name:Ranjitha
     - Choose .pem format
     - Click Create key pair and download the file

- Network: my-vpc

- Subnet: public-subnet

- Enable Auto-assign Public IP

- Security group:

 - Allow SSH (22) from your IP

 - Allow HTTP (80) from anywhere

- Configure Storage

  - Free tier eligible customers can get up to 30 GB of EBS General Purpose (SSD) 
  - Modify as needed withing 30GB for free trail.

- Click Launch Instance in Right side.
- Go to Instance and click Instance we created above.
- At top click **Connect**.

 ![image](https://github.com/user-attachments/assets/575463d6-c6be-4b63-bd46-548cbd9b5dff)

- Refer point 3 to give permission for key that have downloadeed above.
- Copy the command under **Example** to ssh into EC2.
- Go to terminal and Go to directory where pem file had.
- Give perrmisssion to pem file and command fro ssh.

![image](https://github.com/user-attachments/assets/265da759-bb79-47dd-8a6b-9fbb853d183f)

### 7.Create Target Group (for ALB)
This defines which EC2 instances the ALB will forward traffic to.

- Go to EC2 → Load Balancing → Target Groups

- Click Create Target Group

  - Target type: Instances

  - Protocol: HTTP

  - Port: 80

  - VPC: Select same VPC as your EC2

- Click Next

- In Register Targets, select your EC2 instance

- Click Include as pending below

- Click Create Target Group.

### 8.Create an Application Load Balancer

- Go to EC2 → Load Balancing → Load Balancers

- Click Create Load Balancer → Application Load Balancer

- Name it (e.g., my-alb)

- Scheme: Internet-facing (for public)

- IP type: IPv4

- Listeners: HTTP on port 80

- Availability Zones: Select at least 2 subnets in same VPC

- Click Next: Configure Security Settings

#### Configure Security Group for ALB

- Create or select a Security Group for ALB

  - Allow inbound HTTP (port 80) from anywhere (0.0.0.0/0)

  - Click Next: Configure Routing

#### Configure Routing

- Target group: Choose the one you created earlier

- Click Next: Register Targets

- Click Next, then Create

#### Test the Load Balancer

- Go to Load Balancers

- Select your ALB → Description tab → copy the DNS name

- Paste it in your browser:
```
http://<your-alb-dns-name>
```
![image](https://github.com/user-attachments/assets/3c6ac372-4d08-4514-935f-6b8b6e416455)

### 8.Create RDS Database

-Search for RDS.
- Click Create database.
- Under Database creation method, choose:
    - Standard create
- Engine options:MySQL.
- Version:latest MySQL version.
- Templates: Free tier (if eligible) or Production/Dev.
- DB Instance Identifier:
    - Example: RDS-database
- Credentials:
   - Master Username: admin
   - Master Password: yourpassword
   - Confirm Password
- DB instance size:Free tier: db.t3.micro
- Storage:Leave default (e.g., 20 GB)
- Connectivity:
    - VPC: Select existing 
    - Subnet group: auto create
    - Public access: Yes
- VPC security group:
    - Inbound rule allow port 3306 (MySQL) to EC2 instance public IP

- Click Create database

