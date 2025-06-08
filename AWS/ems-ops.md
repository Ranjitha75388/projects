
## Architecture diagram

![image](https://github.com/user-attachments/assets/6ceba5e3-1072-47f8-8b83-0315f074ded4)

## Steps in console

### **Step1**: Login to AWS console  https://console.aws.amazon.com

### **Step 2**: Select **Region** : ap-south-1.

### **Step 3**:Choose Default **VPC**.

### **Step 4**: Choose 3 **public subnets** under default vpc.
 
   - public subnet-1 : Application Load Balancer.

   - Public subnet-2 : Auto scaling group
 
   - public subnet-3 : Amazon RDS
------------------------------------------------------------------------------------------------------------------------

### **Step 5**:Create **EC2 Instance**

1.Type EC2 in search bar.

2.Select Instance ---> **Launch Instance**

- **Name**:ems-Instance
- #### Application and OS Images 
   - **Quick start**:Ubuntu.
   - **Amazon Machine Image (AMI)**: Ubuntu server 24.04 (Free tier eligible)
- #### Instance type
  - t2.micro(Free tier eligible)
- #### Keypair(Login)
  - Create new keypair
  - **Keypair Name**:ranjitha-ec2-keypair
  - **Keypair type**:RSA
  - **Private key file format**: .pem
  - create new pair.
- Key-pair file will be downloaded.

![image](https://github.com/user-attachments/assets/30c3c912-d50f-48f7-90ac-3c1065ab30a6)

- ####  Network settings
  - Select Default VPC.
  - Select Default public subnet-2.
  - **Auto-assign public IP**:Enable.
  - **Firewall**:Select Existing security group --> Default

- #### Configure storage
   - Free tier eligible customers can get up to 30 GB of EBS General Purpose (SSD)
   - Modify as needed.
- Click **Launch Instance** on right side.

3.**SSH** to EC2 Instance

- Once the Instance is create and start **Running** click **connect** at top.
- Copy the command .3 to give permission for keypair.
- In terminal paste the command where keypair is downloaded.
- Copy and paste the command under **Example** to SSH.

![Screenshot from 2025-06-06 13-58-59](https://github.com/user-attachments/assets/bdf02954-c8db-47ef-bc79-3538361ac1a4)

-----------------------------------------------------------------------------------------------------------------------------

### **Step 6**:Create **RDS Database**

- Search as **Aurora and RDS** ---> Databases --->**Create database**.
- Choose a **database creation method** :Standard create.
- **Engine options**: MYSQL.
- **Version**:Latest version.
- **Templates**:Free Tier.
- **Availability and durability**:Default(1 instance)
- **Settings**:
  - **DB instance identifier**:Name(Database)
- **Credentials Settings** 
    - **Master username**: admin
    - **Credentials management**:Self managed.
    - **Master password**:admin12345678
    - **Confirm master password**:admin12345678
- **Instance configuration**:db.t3.micro
- **Storage**:General purpose SSD (20GB)
- Connectivity
   - **VPC**:default VPC
   - **Subnet group**: default public subnet-3
   - **Public access**: Yes
- **VPC security group**:
   - Select Default security group ,add allow port 3306 (MySQL) inbound access from Your EC2 instance's public IP
- Click **create Datebase**.

![image](https://github.com/user-attachments/assets/1d2a3e3f-43ae-44bf-b3e5-0a522c90d03c)


- Login to MYSQL Database fromEC2 Instance.
```
mysql -h <RDS-endpoint> -P 3306 -u <username> -p
```
- Create Database
```
CREATE DATABASE emsops;
```
---------------------------------------------------------------------------------------------------------------------------

### **Step 7**:Dockeriznig the Application

1.SSH into EC2 Instance.

2.Install Docker.

3.Install MYSL client.

4.Clone gitrepo where ems-ops application files located.
```
git clone git@github.com:Ranjitha75388/github-actions.git
cd github-actions
```
5.Create frontend Dockerfile
```
cd reacthooks-frontend
nano Dockerfile
```
```
# Use a base image with Node.js installed
FROM node:14-alpine
 
# Set the working directory in the container
WORKDIR /react-hooks-frontend/
 
# Copy package.json
COPY package*.json ./
 
## Optional: Set environment variables (these can be overridden at runtime)
 
ARG REACT_APP_BACKEND_URL
ENV REACT_APP_BACKEND_URL=${REACT_APP_BACKEND_URL}
 
 
# Install dependencies
RUN npm install
 
# Copy the source code
COPY . .
 
# Expose port 3000
EXPOSE 3000
 
# Command to run
ENTRYPOINT ["npm","start"]
```
6.Create backend Dockerfile
```
cd springboot-backend
nano Dockerfile
```
```
# Use a base image with Java and Maven installed
FROM maven:3.8.4-openjdk-17 AS build
 
# Set the working directory
WORKDIR /app
 
# Copy source code and build the application
COPY . .
 
# Optional: skip tests during build
RUN mvn clean package -DskipTests
 
# -----------------------------
# Create a new clean image just for running
FROM openjdk:17-jdk-slim
 
# Set working directory
WORKDIR /app
 
# Copy the compiled JAR file from the build stage
COPY --from=build /app/target/*.jar app.jar
 
# Optional: Set environment variables (these can be overridden at runtime)
ENV SPRING_DATASOURCE_URL=""
ENV SPRING_DATASOURCE_USERNAME=""
ENV SPRING_DATASOURCE_PASSWORD=""
ENV SPRING_JPA_HIBERNATE_DDL_AUTO=""
 
# Expose port
EXPOSE 8080
 
# Run the jar with env variables
ENTRYPOINT ["java", "-jar", "app.jar"]
```
7.Create Docker images
```
docker build -t frontend .
docker build -t backend .
```
![image](https://github.com/user-attachments/assets/229a4bb3-61df-4c21-816c-ec82c78493c7)

8.Change the path to access backend
```
cd react-hooks-frontend/src/service
nano EmployeeService.js
```
- Change as variablize path to add in docker-compose file
```
const EMPLOYEE_BASE_REST_API_URL = `${process.env.REACT_APP_BACKEND_URL}/api/v1/employees`;
```
- Modify to RDS URL
```
cd springoot-backend/src/main/resources/
nano application.propoerties
```
```
spring.datasource.url=${SPRING_DATASOURCE_URL}
spring.datasource.username=${SPRING_DATASOURCE_USERNAME}
spring.datasource.password=${SPRING_DATASOURCE_PASSWORD}
 
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQLDialect
spring.jpa.hibernate.ddl-auto=${SPRING_JPA_HIBERNATE_DDL_AUTO:update}  # Default: update
```
8.Create docker-compose.yml file
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
      - REACT_APP_BACKEND_URL=http://3.92.216.254:8080
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
9.Build and run the image
```
docker compose -f docker-compose.yml build
docker compose -f docker-compose.yml up -d
```
![image](https://github.com/user-attachments/assets/a6f5d06c-e501-4fec-bb14-9d1f6afc9392)

-------------------------------------------------------------------------------------------------------------------------

### **Step 8**:Create **Application Load Balancer**

#### 1.Create a Target Group

- Go to EC2 → Load Balancing → Target Groups

- Click Create Target Group

   - **Target type**: Instances
 
   - **Target group name**:ems-target-group.

   - **Protocol**: HTTP

   - **Port**: 5000

   - **IP address type**:IPv4

   - **VPC**: Select same VPC as your EC2(Default VPC)

- Health check settings:

   - **Protocol**: HTTP

   - **Path**: /

- Click **Next**

- In **Register Targets**, select your EC2 instance

- Click **Include as pending below**

- Click **Create Target Group**

#### 2.Create an Application Load Balancer

- Go to EC2 → Load Balancing → **Load Balancers**

- Click Create Load Balancer → **Application Load Balancer**

   - **Name**:my-alb

   - **Scheme**: Internet-facing (for public)

   - **IP type**: IPv4

- **Network mapping**:

   - **VPC**: Select Default VPC.Listeners: HTTP on port 80

   - **Availability Zones**: Select at least 2 subnets in same VPC 

- Create or select a **Security Group** for ALB

   - Allow inbound HTTP (port 80) from anywhere (0.0.0.0/0)

- **Listeners and routing**:
   - **Listener**: HTTP (Port 80)
   - **Default action**:Select Target group created above.

- Click **create** Load Balancer.

#### 3.Test the Load Balancer

- Go to Load Balancers.

- Health checks in the target group must succeed.

- Select the ALB → Description tab → copy the DNS name.

- Paste it in your browser:
```
http://<your-alb-dns-name>
```
![Screenshot from 2025-06-06 14-24-10](https://github.com/user-attachments/assets/0b8826da-592d-432f-8f57-cb978d2524cf)

------------------------------------------------------------------------------------------------------------------------------------
### Step 9:Create ECR

#### 1.IAM permission for ECR 
- Go to EC2 --> Select your instance --> Actions -->Security --> Modify IAM role
- Create new IAM role --> Create role
  - **Trusted entity type**: AWS service
  - **Service or use case** : EC2
  - Click **Next**
  - Search for EC2 --> click **AmazonEC2ContainerRegistryFullAccess** --> Next
  - **Role name**: ecr to ec2 connection.
  - create role.
- Back to Modify IAM role page.
- Refresh --> choose "ecr to ec2 connection" -- update an IAM role.

#### 2.GO to ECR 
- Create repository :ems-frontend,ems-backend

![image](https://github.com/user-attachments/assets/78f2a683-09c9-4884-a142-738e9c1b360c)

- choose repository first ems-frontend
- At top click view push commands.

 ![image](https://github.com/user-attachments/assets/932bb365-24e4-4450-947f-234fba0e5341)

#### 3.ssh to EC2 instance 
- Install CLI command
- In image point 1:authentication copy the command and run in ec2 Instance.
- Build the docker image from Dockerfile directory.
```
docker build -t ems-frontend .
```
- Tag and push the image as command shown in image point 3,4.
```
docker tag ems-frontend:latest 179859935027.dkr.ecr.us-east-1.amazonaws.com/ems-frontend:latest
docker push 179859935027.dkr.ecr.us-east-1.amazonaws.com/ems-frontend:latest
```
- And then in **docker-compose.yml** change to pull image from ECR.
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
- By using ALB we can access application in browser.

--------------------------------------------------------------------------------------------------------------------------------------

### Step 10:Create Secrets in AWS Secrets Manager
To securely manage your database credentials and other sensitive information, you can use AWS Secrets Manager.

#### 1.IAM permission for Secrets manager.

- Go to EC2 --> Select your instance --> Actions -->Security --> Modify IAM role
- Create new IAM role --> Create role
  - **Trusted entity type**: AWS service
  - **Service or use case** : EC2
  - Click **Next**
  - Search for secret --> SecretsManagerReadWrite  --> Next
  - **Role name**: secrets to ec2 connection.
  - create role.
  - Back to Modify IAM role page.
- Refresh --> choose "secrets to ec2 connection" --> update an IAM role.

#### 2.Create secret manager

- Go to **Secrets Manager**.

- Click "**Store a new secret**".

- (**OPTION-1**)Select secret type 

    - Choose "**Other type of secret**".

    - Enter key-value pairs like:
```
 SPRING_DATASOURCE_URL : jdbc:mysql://database-2.cpkcgnnx2rja.us-east-1.rds.amazonaws.com:3306/ems?useSSL=false&allowPublicKeyRetrieval=true
 SPRING_DATASOURCE_USERNAME : admin
 SPRING_DATASOURCE_PASSWORD : admin12345678
 SPRING_JPA_HIBERNATE_DDL_AUTO : update
```
- **(OPTION-2)** Select secret type
     - choose "**Credential for Amazon RDS Database**"
     - Credentials
         - Username:admin
         - Password:admin12345678
      - Database:Select above created RDS database
      
- **(OPTION-3)** Select secret type
     - While creating RDS database
           - **Credentials management** :Selecct Managed in AWS secret manager
     - Automatically new secret add in secrets manager.
     - To check secret values click created secrets ---> overview--> secret value --> Retrive secret value.
  ![image](https://github.com/user-attachments/assets/0e230c05-f134-41ff-9278-2c20bc4e59c3)


- **Secret name**:ems-app/mysql-creds

- Next : Optionally enable automatic rotation.
- Click **Store**.

#### 3.verify from ec2
```
aws secretsmanager get-secret-value --secret-id your-secret-name --region us-east-1
```
#### 4.Create Script on EC2

```
nano secret.sh
```
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
- Make it executable:
```
chmod +x secret.sh
```
- Ensure jq is Installed
```
sudo apt update

sudo apt install jq -y
```
#### 5.Update docker-compose.yml
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
----------------------------------------------------------------------------------------------------------------

### 11.Crete Auto Scaling Group

#### STEP 1: Create an AMI from Your EC2 Instance

This captures your EC2 setup so that Auto Scaling can create identical instances.

- Go to EC2 Dashboard.

- Select your EC2 instance.

- Click Actions > Image and templates > Create Image.

- Name: ems-app-ami) and click Create Image.

- This takes a few minutes. Note the **AMI ID** (e.g., ami-0abcd1234efgh5678).

![image](https://github.com/user-attachments/assets/2d558da8-0b14-4fc9-a082-8b5ac2748ce8)


#### STEP 2: Create a Launch Template (RECOMMENDED)

This template tells ASG how to launch new EC2s.

- Go to EC2 > Launch Templates > Create Launch Template

- Name: ems-launch-template

- AMI ID: Use the one from step 1.

- Instance type: e.g., t3.medium

- Key Pair: Optional for SSH

- Security Group: Same as your current EC2

- IAM Role: Must allow ECR, Secrets Manager, etc.

- Click Create Launch Template

#### STEP 3: Create an Auto Scaling Group (ASG)

- Go to EC2 > Auto Scaling Groups > Create Auto Scaling group

- Name: ems-asg

- Launch template: Select the one you just created

- Network settings: Select VPC and Subnets where the EC2 should be deployed

- Load Balancer:Select Application Load Balancer created above
        
- Group size:

    - Min: 1

    - Desired: 2

    - Max: 5

 - Scaling policies:

     - Choose "Target tracking scaling policy"

     - Metric: Average CPU utilization

      - Target value: 50% or based on your need

- Click Create Auto Scaling Group.

#### STEP 4: Test Auto Scaling

- Run the application using Application loadbalancer.

- Check by:

    - Increasing load (CPU stress).

    -  Stopping an instance to see if it auto-replaces.

    - Watching the ASG dashboard.











