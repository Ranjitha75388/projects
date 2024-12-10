


# Full Stack Web Application

Full stack development refers to the process of building web applications that include both client-side (front-end) and server-side (back-end) components.

### Detailing structure of Application:
- ReactJS Frontend
- Java SpringBoot backend
- MySQL RDBMS

### The Outline of this Project Includes:
- Architecture Diagram
- Flow Diagram
- Installing Prerequisites(phase-0)
- Setup, Build, and Manual Deployment of the Application (phase-1)
- Daemonizing the Services(phase-2)
- Dockerizing the Application(phase-3)
- Creating a Docker Compose File and Running the Application(phase-4)

## Architecture Diagram

https://lucid.app/lucidchart/baad1f5f-1568-4597-af59-7a28c831443b/edit?view_items=NzzwBwRoH9A~&invitationId=inv_4bb12a6b-b150-442b-82d9-5a96de130474
    






    







    

- ### Client (ReactJS Frontend)

    Represents the user interface where users interact with the application.

- ### Server (Java Spring Boot Backend)

    Handles business logic, processes requests from the frontend, and interacts with the database.

- ### Database (MySQL)

    Stores application data and handles data retrieval and manipulation requests from the backend.

## Flow Diagram
                      [ User Action ]
                                |
                                |
                      [ ReactJS Frontend ]
                                |  HTTP Request
                                |
                    [ Java Spring Boot Backend ]
   
                                |   Database Query
                                |
                         [ MySQL Database ]
                                |    Data Response
                                |
                     [ Java Spring Boot Backend ]
                                |  HTTP Response
                                |
                         [ ReactJS Frontend ]
                                |
                                |
                             [ UI Update ]


- User Action: A user performs an action on the ReactJS frontend (e.g., submits a form).

- API Call: The frontend sends an HTTP request to the Spring Boot backend.

- Request Handling: The Spring Boot backend receives the request and processes it.

- Database Interaction: The backend interacts with the MySQL database to retrieve or modify data based on the request.

- Response Generation: The backend generates a response (success message, data) and sends it back to the frontend.

- UI Update: The ReactJS frontend receives the response and updates the user interface accordingly.

## Installing Prerequisites

- ### Following toolset/package to be installed
    - Java 17
    - Maven 3.8.8
    - NodeJs 14.x
    - MySQL 8.x

## Setup, Build, and Manual Deployment of the Application
- Backup- setup,Build and Run the application
- Frontend- setup ,Build and Run the application

## Daemonizing the Services
- Create SystemD Service for java backend
- Daemon Reload & systemctl the Service
- Create SystemD Service for react frontend
- Daemon Reload & systemctl the Service

## Dockerizing the Application
- Create a Dockerfile for Frontend
- create a Dockerfile for backend
    
## Creating a Docker Compose File
Create a dockercompose file using above Dockerfile of each service and run the application automatically.


