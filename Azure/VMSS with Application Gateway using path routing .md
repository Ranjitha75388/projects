# Application Gateway

Azure Application Gateway is a layer 7 (HTTP/HTTPS) load balancer that manages and routes traffic to backend servers based on web requests. It provides secure, scalable, and high-performance traffic distribution for applications.

## Features of Azure Application Gateway

#### Layer 7 Load Balancing

   - Routes HTTP/HTTPS requests based on URL paths, host headers, and query parameters.
   - Example: /api requests go to backend A, while /images go to backend B.

#### URL-Based Routing

   - Allows path-based routing, meaning different URL paths can be forwarded to specific backend pools.
   - Example: /users goes to VM 1, while /products goes to VM 2.

#### Autoscaling & High Availability

   - Automatically scales based on traffic demands.
   - Ensures zero downtime with multiple instances.

#### Health Monitoring (Health Probes)

   - Regularly checks backend server health.
   - Automatically removes unhealthy instances from traffic routing.

## Key Components of Azure Application Gateway

![image](https://github.com/user-attachments/assets/3b171a8b-6604-4408-a8be-cb5c5724afa2)

## Architecture Diagram

![image](https://github.com/user-attachments/assets/1b11c078-6bcc-4c98-8ba7-c8ddc3370e3e)


## Step by step configuration in Azure portal

### Step 1 : Create Resourse group

### Step 2 : Create NAT Gateway (frontend vmss and backend vmss are in private subnet)

### Step 3 : Create NSG 

### Step 4 : Create Virtual network

## Step 5 : Create subnet (seperate subnet for application gateway)

- #### Add private subnet and NAT Gateway,NSG for  frontend vmss and backend vmss
   
![image](https://github.com/user-attachments/assets/3a7de545-f9c8-4e13-a3ff-1ba7a8948732)

## Step 6 : Create Application gateway

![image](https://github.com/user-attachments/assets/45548ca2-5f08-464b-88ed-450c22ebe153)
![image](https://github.com/user-attachments/assets/05c07db3-72e5-4b54-850b-7aa688b4f77d)

### **NEXT: Frontends** :Create public ip

![image](https://github.com/user-attachments/assets/4f2fdc42-1306-4471-80ed-3172742c00f0)

### **NEXT: Backend pools** : Create backend pool for frontend vmss and backend vmss and **Add**

![image](https://github.com/user-attachments/assets/db00485e-5fd7-4873-a1e4-b3cedd5a5a39)
![image](https://github.com/user-attachments/assets/5a219237-ae6e-42c6-b64b-4f20bbab4034)

## **NEXT: Configuration** : Add Routing rules

![image](https://github.com/user-attachments/assets/ca6386de-a785-4121-9cf2-e78caff77cb3)

![image](https://github.com/user-attachments/assets/f70e04bf-3ecf-4987-9683-1e42a5b2800e) 

### NEXT:Backend targets

![image](https://github.com/user-attachments/assets/0758d724-14e3-4b31-82ae-a7636633eb08)
![image](https://github.com/user-attachments/assets/82c91a8c-613b-43c6-9b62-08dac65a07b6)

### **Backend Targets**

![image](https://github.com/user-attachments/assets/705e98a4-71f4-4e38-a3e2-4932efeed42a)

## Routing rule for Backend path: /api/*

![image](https://github.com/user-attachments/assets/4b58d8f9-0dc8-4f87-bdbd-d513c8f8ff64)

![image](https://github.com/user-attachments/assets/e3cde5e1-d10f-4155-98cc-30ee6ddeaa50)
![image](https://github.com/user-attachments/assets/d6b3e76e-962a-491f-9919-9372daf9952d)

### Backend Targets

![image](https://github.com/user-attachments/assets/2a9b0926-f9d0-4b3f-9bfb-f56ea1a995f8)

## Health probes

![image](https://github.com/user-attachments/assets/28efa8c0-a32f-48ea-93a5-887dd2d1ad88)
![image](https://github.com/user-attachments/assets/51600c73-21d6-45b7-af17-1fcfaa236637)

### Review+Create

## Step 7: Configrue frontend vmss

![image](https://github.com/user-attachments/assets/7ed390b9-14ca-4fd5-9ef4-df2c87afc997)
![image](https://github.com/user-attachments/assets/3bcca5d1-531f-4a2b-a512-c527bf161441)
![image](https://github.com/user-attachments/assets/ddde99b4-a318-4abe-a107-f3c9840a9342)

### NEXT: Networking

- NIC --> none  , public ip ---> Disabled
  
![image](https://github.com/user-attachments/assets/9d75594d-0f17-4076-a641-542d9f1fcb00)
![image](https://github.com/user-attachments/assets/b657ee23-16eb-42e1-845d-7e4370ff4f4c)

**NEXT: Advanced**  : Add frontend script 

![image](https://github.com/user-attachments/assets/f7fe3c85-5386-4646-8bba-a13c28ebc841)

### Review+create

## NSG for Frontend vmss

![image](https://github.com/user-attachments/assets/e3a7b2b7-c606-46df-968b-0604b00b426c)

## Step 8: Configure Backend vmss

![image](https://github.com/user-attachments/assets/3dd9e4b1-219e-4b2e-9077-da1e08e4adaa)

### NEXT: Networking

![image](https://github.com/user-attachments/assets/f0e8387f-bbd1-40fd-85f7-1db7872a0dc2)
![image](https://github.com/user-attachments/assets/c3c73e76-f167-4a4d-ae09-675faa6a1c23)

### **NEXT : Advanced** : Add backend script

![image](https://github.com/user-attachments/assets/0f612c59-53a7-4397-8f4a-d899605c6ffd)

### Review+create

## NSG for Backend vmss

![image](https://github.com/user-attachments/assets/f351556a-8b17-432e-9631-b65982948960)

## Step 9: Check created vm's are in Healthy state

- Application Gateway ---> Rules ---> Backend health

![image](https://github.com/user-attachments/assets/437bbfc7-cf26-4a9b-9cb2-60e957a492d2)

## Step 10: Check in browser 

### Using frontend path : Applicatio-gateway-public-ip:3000/add-employee

![image](https://github.com/user-attachments/assets/46537475-8ff1-4f38-a165-f9cbf5b5392e)

###  Applicatio-gateway-public-ip:3000/employees

![Screenshot from 2025-02-26 14-21-25](https://github.com/user-attachments/assets/64099329-4ca7-422b-8267-936a97cf67cf)

### Using Backend path : Application-gateway-public-ip:8080/api/v1/employees

![Screenshot from 2025-02-24 14-11-17](https://github.com/user-attachments/assets/34276923-e3cf-48b3-a536-da1f83b6c4d1)

## Step 11 : Check in terminal

![image](https://github.com/user-attachments/assets/9597c996-12ae-4a49-ba0a-127b49f64702)


