# Dockerizing the Application(phase-3)

This phase guides to Dockerizing the frontend and backend services .

Before Dockerizing refer the 'phase 1' (https://github.com/Ranjitha75388/Jumisa-Technology/blob/main/3-Tier%20web%20Application/Build%20and%20deploy%20application(phase-1).md)

## 1.React Frontend

### Step1 :Navigate to Frontend Directory
```
cd /home/logi/Downloads/ems-ops-phase-0/react-hooks-frontend
```
### Step2 :Create a Dockerfile
```
sudo nano Dockerfile
```
### Step3:
```bash

# Use the official Node.js image as a base
FROM node:14

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json files to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Expose port 3000 for the application
EXPOSE 3000

# Command to run the application
CMD ["npm", "start"]
```
### Explanation of the Dockerfile Steps:

- Base Image: The FROM node:14 line specifies that we are using Node.js version 14 as our base image.

- Working Directory: The WORKDIR /app command sets  /app as the working directory inside the container. All subsequent commands will be run from this directory.

- Copy Dependencies: The COPY package*.json ./ command copies your package.json and package-lock.json files into the container.

- Install Dependencies: The RUN npm install command installs all the packages listed in your package.json.

- Copy Application Code: The COPY . . command copies all other application files into the container.

- Expose Port: The EXPOSE 3000 line tells Docker that the container will listen on port 3000 at runtime.

- Start Command: Finally, CMD ["npm", "start"] specifies the command to run when starting the container, which in this case starts your React application.

## 2. Springboot Backend :

### Step1 : Navigate to Springboot directory
```
cd /home/logi/Downloads/ems-ops-phase-0/springboot-backend
```
### Step2 :Create Dockerfile
```
sudo nano Dockerfile
```
### Step3 :
```
# Use an OpenJDK image
FROM openjdk:17-jdk-slim

# Set the working directory
WORKDIR /app

# Copy the JAR file into the image
COPY target/springboot-backend-0.0.1-SNAPSHOT.jar app.jar

# Expose port 8080 for the backend
EXPOSE 8080

# Run the Spring Boot application
CMD ["java", "-jar", "app.jar"]
```
### Explanation of the Dockerfile

- Base Image:This line specifies that your container will use the OpenJDK 17 JDK slim image as its base. The slim variant is lightweight, making it suitable for production environments.

- Set Working Directory:WORKDIR /app sets the working directory inside the container where all subsequent commands will be executed.

- Copy the jar file:COPY target/springboot-backend-0.0.1-SNAPSHOT.jar app.jar command copies the generated JAR file from the build stage into the final image.

- EXPOSE 8080 indicates that your application will listen on port 8080.

- Run the Spring Boot application:CMD ["java", "-jar", "app.jar"]command specifies how to run your Spring Boot application when starting a container from this image.

### Another method of creating Docker file for springboot(optional)
```
# Stage 1: Build the application using Maven
FROM openjdk:17-jdk-slim AS build

# Set environment variables for Maven
ENV MAVEN_VERSION=3.8.8
ENV M2_HOME=/opt/apache-maven-$MAVEN_VERSION
ENV PATH="$M2_HOME/bin:$PATH"

# Install wget and other necessary tools
RUN apt-get update && \
    apt-get install -y wget vim && \ 
    apt-get clean
RUN apt-get update && \
    apt-get install -y default-mysql-client && \
    rm -rf /var/lib/apt/lists/*

# Download and install Maven
RUN wget https://dlcdn.apache.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz && \
    tar -xvf apache-maven-$MAVEN_VERSION-bin.tar.gz && \
    mv apache-maven-$MAVEN_VERSION /opt/ && \
    rm apache-maven-$MAVEN_VERSION-bin.tar.gz

# Set working directory for building the application
WORKDIR /app

# Copy the JAR file from the build stage to the final image
COPY target/springboot-backend-0.0.1-SNAPSHOT.jar app.jar
COPY src/main/resources/application.properties application.properties

# Expose the port that your application will listen on
EXPOSE 8080

# Run the Spring Boot application
CMD ["java", "-jar", "app.jar"]

#Run the application without stop
#CMD ["tail", "-f", "/dev/null"]
```
### Note:MYSQL Dockerfile created directly in docker-compose file.
