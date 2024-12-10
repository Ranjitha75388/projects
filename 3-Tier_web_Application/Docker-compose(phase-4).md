
# Docker-compose file (phase-4)

Docker Compose is a tool that define and run multiple Docker containers using a single configuration file, typically named docker-compose.yml. This file uses YAML syntax to specify the services, networks, and volumes required for the application.

This phase guides to compose frontend,backend and MYSQL services.

Before composing refer phase-3 (https://github.com/Ranjitha75388/Jumisa-Technology/blob/main/3-Tier%20web%20Application/Dockeerizing%20the%20services(phase-3).md)

### Step1 : Navigate to Directory
```
        cd ~/Downloads/ems-ops-phase-0
```
### Step2 : Create docker-compose file
```
        nano docker-compose.yml
```
### step3 : Add the services

```
version: '3.8'

services:
  # React Frontend Service
  frontend:
    build:
      context: ./react-hooks-frontend
      dockerfile: Dockerfile
    ports:
      - "3001:3000"  # React will be served on port 3000
    networks:
      - frontend_network
    depends_on:
      - backend

  # Spring Boot Backend Service
  backend:
    build:
      context: ./springboot-backend
      dockerfile: Dockerfile
    ports:
      - "8080:8080"  # Spring Boot app on port 8080
    environment:
      SPRING_DATASOURCE_URL: jdbc:mysql://database:3306/mynewdatabase?useSSL=false&allowPublicKeyRetrieval=true
      SPRING_DATASOURCE_USERNAME: root
      SPRING_DATASOURCE_PASSWORD: ranjitha
    depends_on:
      - database
    networks:
      - frontend_network
      - backend_network

# MySQL Database Service
  database:
    image: mysql:8
    environment:
      MYSQL_DATABASE: mynewdatabase
      MYSQL_USER: ranjitha
      MYSQL_PASSWORD: ranjitha
      MYSQL_ROOT_PASSWORD: ranjitha
    ports:
      - "3306:3306"  # Database accessible on port 3307 (optional)
    volumes:
      - mysql-data:/var/lib/mysql  # Persistent volume for database
    networks:
      - backend_network
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "database"]
      interval: 30s
      timeout: 10s
      retries: 5

# Network Configuration to Isolate Services
networks:
  frontend_network:
    driver: bridge
  backend_network:
    driver: bridge

# Persistent Volume for MySQL Database
volumes:
  mysql-data:
    driver: local
```
### Explanation of the Docker-compose file

- version: '3.8' : The version key specifies the version of the Docker Compose file format being used.

- services: The services section defines all the containers that will be part of the application. Each service can have its configuration options, such as which image to use, environment variables, ports, and volumes.

### React Frontend Service:

- frontend: This is the name of the service for the React application.

- build: Specifies how to build the container.


     * context: The directory where the Dockerfile for the frontend is located (current path/react-hooks-frontend).

     * dockerfile: The name of the Dockerfile (assumed to be Dockerfile).

- ports: Maps port 3001 on the host to port 3000 in the container (3000 default port for React applications).

- networks: Connects this service to frontend_network.

- depends_on: Specifies that this service should start after the backend service is up and running.

### Spring Boot Backend Service:

- backend: This is the name of the service for the Spring Boot application.

- build: It specifies to find the Dockerfile for building.(currentpath/springboot-backend)

- ports: Maps port 8080 on the host to port 8080 in the container (8080 default port for Spring Boot applications).

- environment: Sets environment variables needed by Spring Boot to connect to MySQL.

     * SPRING_DATASOURCE_URL: The JDBC URL for connecting to MySQL, specifying the database name and connection options.
     * SPRING_DATASOURCE_USERNAME:should be default 'root' user.
     * SPRING_DATASOURCE_PASSWORD:password of the root user.

- depends_on: Ensures that this service starts after the database service is running.

- networks: Connects this service to both frontend_network and backend_network.

### Database Service

- database: This is the name of the service for MySQL.

- image: Uses the official MySQL image version 8.

- environment: Sets up MySQL with necessary configuration.

     * MYSQL_DATABASE creates a new database named mynewdatabase.

     * MYSQL_USER, MYSQL_PASSWORD, and MYSQL_ROOT_PASSWORD set credentials for accessing MySQL.

- ports: Maps port 3306 on the host to port 3306 in the container (3306 default MySQL port).

- volumes: Defines a persistent volume (mysql-data) that stores MySQL data in /var/lib/mysql, ensuring data persistence across container restarts.

- networks: Connects this service to backend_network.

- healthcheck: Monitors the health of the MySQL container by pinging it every 30 seconds. If it fails, it will retry up to five times before considering it unhealthy.

### Network Configuration

- This section defines custom networks for isolating services.

- frontend_network and backend_network are both created using the bridge driver, which allows containers on these networks to communicate with each other while keeping them isolated from other containers not on these networks.

### Persistent Volume

- This section defines a named volume called mysql-data. The driver specifies that it uses local storage, which means that data will be stored on your local filesystem.

### Step4 : Build the compose file
```
        docker-compose build
```
### Step5 : Run the compose file
```
        docker-compose up
```
### Step6 : Check the container status

Check whether frontend,backend,MYSQL container is in running stage.
```
        docker ps
```
### Step7 : Check the URL status 
```
        localhost:3001
```
Now the Employee list page will recevied.In that Add employee details and submit it.
![Screenshot from 2024-12-03 16-45-04](https://github.com/user-attachments/assets/1b4fb55c-ed7a-4b24-913e-a2d1596ca582)


### Step8 : Stopping Your Application

To stop all running containers defined in your Compose file, you can run:
```
        docker-compose down
```
### Step9 : Check logs for container
```
        docker-compose logs (name of the service)
```


### ERROR

''[PersistenceUnit: default] Unable to build Hibernate SessionFactory; nested exception is org.hibernate.exception.JDBCConnectionException: Unable to open JDBC Connection for DDL execution [Communications link failure
backend_1   | 
backend_1   | The last packet sent successfully to the server was 0 milliseconds ago. The driver has not received any packets from the server.] [n/a]
backend_1   | 2024-11-30T10:30:26.920Z  INFO 1 --- [           main] o.apache.catalina.core.StandardService   : Stopping service [Tomcat]
backend_1   | 2024-11-30T10:30:26.934Z  INFO 1 --- [           main] .s.b.a.l.ConditionEvaluationReportLogger : 
backend_1   | 
backend_1   | Error starting ApplicationContext. To display the condition evaluation report re-run your application with 'debug' enabled.
backend_1   | 2024-11-30T10:30:26.948Z ERROR 1 --- [           main] o.s.boot.SpringApplication               : Application run failed''


### Solution

''SPRING_DATASOURCE_USERNAME: root  

SPRING_DATASOURCE_PASSWORD: ranjitha''

Set default 'root' user and password..If normal user name given above error occur.

