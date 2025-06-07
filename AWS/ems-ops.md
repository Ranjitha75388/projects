
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
  - Select Default public subnet.
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
7.Change the path to access backend
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
      - REACT_APP_BACKEND_URL=http://54.165.120.121:8080
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
      - SPRING_DATASOURCE_URL=jdbc:mysql://database-1.c0n8mseiazqy.us-east-1.rds.amazonaws.com:3306/ems?useSSL=false&allowPublicKeyRetrieval=true
      - SPRING_DATASOURCE_USERNAME=admin
      - SPRING_DATASOURCE_PASSWORD=admin2000
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
10.Login to MYSQL Database
```
mysql -h <RDS-endpoint> -P 3306 -u <username> -p
```
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


 


















