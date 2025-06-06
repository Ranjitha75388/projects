
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
- Docker compose.yml
```
version: '3.8'
 
services:
  frontend:
    build:
      context: ./react-hooks-frontend
      dockerfile: Dockerfile
    ports:
      - "5000:3000"
    environment:
      - REACT_APP_BACKEND_URL=http://18.204.206.240:8080
    depends_on:
      - backend
    networks:
      - ems-ops
 
  backend:
    build:
      context: ./springboot-backend
      dockerfile: Dockerfile
    ports:
      - "8080:8080"
    environment:
      - SPRING_DATASOURCE_URL=jdbc:mysql://database-2.cpkcgnnx2rja.us-east-1.rds.amazonaws.com:3306/ems?useSSL=false&allowPublicKeyRetrieval=true
      - SPRING_DATASOURCE_USERNAME=admin
      - SPRING_DATASOURCE_PASSWORD=admin12345678
      - SPRING_JPA_HIBERNATE_DDL_AUTO=update
    networks:
      - ems-ops
 
 
networks:
  ems-ops:  # Let Docker create and manage this network
    driver: bridge
```

IAM permission for ECR 

- Go to EC2 --> Select your instance --> Actions -->Security --> Modify IAM role
- Create new IAM role --> Create role
  - Trusted entity type: AWS service
  - Service or use case : EC2
  - next
  - search for EC2 --> click AmazonEC2ContainerRegistryFullAccess --> next
  - role name: ecr to ec2 connection.
  - create role.
- Back to Modify IAM role page.
- Refresh --> choose "ecr to ec2 connection" -- update an IAM role.

GO to ECR 
- Create repository :ems-frontend
- choose repository ems-frontend
- at top click view push commands.
- point 1:authentication copy the command and run in ec2 Instance.

- ![image](https://github.com/user-attachments/assets/932bb365-24e4-4450-947f-234fba0e5341)


Before that ssh to EC2 instance 
Install CLI command
Update the System

sudo apt update -y
sudo apt upgrade -y

✅ Step 3: Install Required Tools
Install unzip (required to unzip the CLI installer)

sudo apt install unzip -y

✅ Step 4: Download AWS CLI v2 Installer

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

✅ Step 5: Unzip the Installer

unzip awscliv2.zip

✅ Step 6: Run the Installer

sudo ./aws/install

✅ Step 7: Verify the Installation

aws --version

_ Run the authentication command
- build the docker image from Dockerfile directory.
- tag and push the image as command shown in image.
- And then in docker-complose.yml change to pull image from ECR.
```
version: '3.8'

services:
  frontend:
    image: 179859935027.dkr.ecr.us-east-1.amazonaws.com/ems-frontend:latest
    ports:
      - "5000:3000"
    environment:
      - REACT_APP_BACKEND_URL=http://18.204.206.240:8080
    depends_on:
      - backend
    networks:
      - ems-ops

  backend:
    image: 179859935027.dkr.ecr.us-east-1.amazonaws.com/ems-backend:latest
    ports:
      - "8080:8080"
    environment:
      - SPRING_DATASOURCE_URL=jdbc:mysql://database-2.cpkcgnnx2rja.us-east-1.rds.amazonaws.com:3306/ems?useSSL=false&allowPublicKeyRetrieval=true
      - SPRING_DATASOURCE_USERNAME=admin
      - SPRING_DATASOURCE_PASSWORD=admin12345678
      - SPRING_JPA_HIBERNATE_DDL_AUTO=update
    networks:
      - ems-ops

networks:
  ems-ops:
    driver: bridge
```
- by using ALB we access access in browser.




  ## Secrets manager
  1.create secrets manager using other type database
  store
  2.IAM permission give secrets ec2 -->modify IAM role
  
  Go to the IAM Console → Roles.

Find and click on the role attached to your EC2 instance.

Go to the Permissions tab.

Click Add permissions > Attach policies.

Search and select SecretsManagerReadWrite (or create a custom policy—see below).

Click Attach policy.

3.verify from ec2
```
aws secretsmanager get-secret-value --secret-id your-secret-name --region us-east-1
```

#### Step 3: Create secret.sh Script on EC2
```
nano secret.sh
```
Paste this:
```
#!/bin/bash

# Get secrets from AWS
SECRET_JSON=$(aws secretsmanager get-secret-value \
  --secret-id ems-secret-manager \
  --region us-east-1 \
  --query SecretString \
  --output text)

# Parse with jq
export SPRING_DATASOURCE_URL=$(echo $SECRET_JSON | jq -r .SPRING_DATASOURCE_URL)
export SPRING_DATASOURCE_USERNAME=$(echo $SECRET_JSON | jq -r .SPRING_DATASOURCE_USERNAME)
export SPRING_DATASOURCE_PASSWORD=$(echo $SECRET_JSON | jq -r .SPRING_DATASOURCE_PASSWORD)

# Run Docker Compose
docker compose up -d
```
Make it executable:
```
chmod +x secret.sh
```
✅ Step 4: Update docker-compose.yml

Your docker-compose.yml should have:
```
services:
  backend:
    image: 179859935027.dkr.ecr.us-east-1.amazonaws.com/ems-backend:latest
    ports:
      - "8080:8080"
    environment:
      - SPRING_DATASOURCE_URL
      - SPRING_DATASOURCE_USERNAME
      - SPRING_DATASOURCE_PASSWORD
    networks:
      - ems-ops
```

✅ Step 5: Ensure jq is Installed

sudo apt update
sudo apt install jq -y

- Run the docker compose up command without "sudo"
