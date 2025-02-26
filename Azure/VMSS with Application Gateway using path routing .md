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

## Step by step configuration Azure portal

#### Step 1 : Create Resourse group

#### Step 2 : Create NAT Gateway (frontend vmss and backend vmss are in private subnet)

#### Step 3 : Create Virtual network

#### Step 4 : Create subnet (seperate subnet for application gateway)

![image](https://github.com/user-attachments/assets/3a7de545-f9c8-4e13-a3ff-1ba7a8948732)

#### Step 5 : Create Application gateway

![image](https://github.com/user-attachments/assets/45548ca2-5f08-464b-88ed-450c22ebe153)
![image](https://github.com/user-attachments/assets/05c07db3-72e5-4b54-850b-7aa688b4f77d)

**NEXT: Frontends** :Create public ip

![image](https://github.com/user-attachments/assets/4f2fdc42-1306-4471-80ed-3172742c00f0)

**NEXT: Backend pools** : Create backend pool for frontend vmss and backend vmss and **Add**

![image](https://github.com/user-attachments/assets/db00485e-5fd7-4873-a1e4-b3cedd5a5a39)
![image](https://github.com/user-attachments/assets/5a219237-ae6e-42c6-b64b-4f20bbab4034)

**NEXT: Configuration** : Add Routing rules

![image](https://github.com/user-attachments/assets/ca6386de-a785-4121-9cf2-e78caff77cb3)

**For Listener**

![image](https://github.com/user-attachments/assets/f70e04bf-3ecf-4987-9683-1e42a5b2800e)

**For Backend Targets**

![image](https://github.com/user-attachments/assets/0758d724-14e3-4b31-82ae-a7636633eb08)

**Add Frontend path: /***

![image](https://github.com/user-attachments/assets/82c91a8c-613b-43c6-9b62-08dac65a07b6)

**Backend Targets**

![image](https://github.com/user-attachments/assets/705e98a4-71f4-4e38-a3e2-4932efeed42a)

## Routing rule for Backend path: /api/*

![image](https://github.com/user-attachments/assets/4b58d8f9-0dc8-4f87-bdbd-d513c8f8ff64)

![image](https://github.com/user-attachments/assets/e3cde5e1-d10f-4155-98cc-30ee6ddeaa50)

![image](https://github.com/user-attachments/assets/d6b3e76e-962a-491f-9919-9372daf9952d)

### Backend Targets

![image](https://github.com/user-attachments/assets/2a9b0926-f9d0-4b3f-9bfb-f56ea1a995f8)

## Health probes



### Review+Create




 
