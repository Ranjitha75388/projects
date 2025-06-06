
## Architecture diagram

![image](https://github.com/user-attachments/assets/6ceba5e3-1072-47f8-8b83-0315f074ded4)

## Steps in console

Step1: Login to AWS console  https://console.aws.amazon.com

Step 2: Select Region : ap-south-1.

Step 3:Choose Default VPC.

Step 4: Choose 3 public subnets under default vpc.
 
 1.public subnet-1 : Application Load Balancer.

 2.Public subnet-2 : Auto scaling group
 
 3.public subnet-3 : Amazon RDS

Step 5:Create EC2 Instance

1.Type EC2 in search bar.

2.Select Instance ---> Launch Instance

- #### Name and Tags
 - Name:ems-Instance

- #### Application and OS Images 
   - Quick start:Ubuntu.
   - Amazon Machine Image (AMI): Ubuntu server 24.04 (Free tier eligible)
- #### Instance type
  - t2.micro(Free tier eligible)
- #### Keypair(Login)
  - Create new keypair
  - Keypair Name:ranjitha-ec2-keypair
  - Keypair type:RSA
  - Private key file format: .pem
  - create new pair.
  - Key-pair file will be downloaded.

![image](https://github.com/user-attachments/assets/30c3c912-d50f-48f7-90ac-3c1065ab30a6)

- ####  Network settings
- Select Default VPC.
- Select Default public subnet.
- Auto-assign public IP:Enable.
- Firewall:Select Existing security group --> Default

- #### Configure storage
- Free tier eligible customers can get up to 30 GB of EBS General Purpose (SSD)
- Modify as needed.

- Click **Launch Instance** on right side.

3.SSH to EC2 Instance

- Once the Instance is create and start **Running** click **connect** at top.
- Copy the command to authenticate the keypair.
- In terminal paste the command where keypair is downloaded.
- Copy and paste the command to SSH.

## Create RDS Database

- Search as Aurora and RDS ---> Databases --->Create database.
- Choose a database creation method :Standard create.
- Engine options: MYSQL.
- Version:Latest version.
- Templates:Free Tier.
- Availability and durability:Default(1 instance)
- Settings:
  - DB instance identifier:Name(Database)
- Credentials Settings 
    - Master username: admin
    - Credentials management:Self managed.
    - Master password:admin12345678
    - Confirm master password:admin12345678
  
- Instance configuration:db.t3.micro
- Storage:General purpose SSD (20GB)
- Connectivity
     - 


## Dockeriznig the Application

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
- Change as variablize path to add i docker-compose file
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
8.Login to MYSQL Database
```
mysql -h <RDS-endpoint> -P 3306 -u <username> -p
```
9.Create docker-compose.yml file
``














 
- 


















