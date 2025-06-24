# Palipoint Application - AWS Infrastructure and Design Documentation

   This document provides a overview of the cloud architecture and application design of the Palipoint system. 

### Overview

- AWS Region & Networking
   - AWS Region
   - VPCs and Subnets
- Environments
   - Non-Production
   - Production
   - CI/CD (GitLab)
   - Security
- Application Functionaliy
- CI/CD Workflow
- Data Flow Summary


## AWS Region & Networking

### 1.AWS Region

   All resources are deployed in Asia Pacific (Mumbai) - ap-south-1.

### 2.VPCs and Subnets

The infrastructure includes three separate Virtual Private Clouds (VPCs):
   
 1. **Default VPC** – for Non-Production (Dev/QA)
    
 2. **prod-vpc** – for Production
    
 3. **Palipoint-VPC** – for CI/CD operations (GitLab)

Each VPC contains **public subnets** where services are deployed.

## Environments

### 1. Non-Production (Dev/QA)

**Domain:** www.palipoint.in

**Components:**

- **Dev-QA-Server** (t3a.large): Runs frontend and backend in Docker.

- **Dev-Kafka-Server** (t3a.small): Handles message notifications.

- **Amazon RDS** (PostgreSQL 15.8): Stores application data (development database)(db.t3.micro)

- **ElastiCache** Redis (Serverless 7.1): For caching

- **ElasticSearch**: Logs and search functionality.

- **S3 Bucket** (palipoint-dev): Stores static files like images, HTML, CSS

- **CloudFront**: Delivers content efficiently to users 

### 2.Production

**Domain**: www.palipoint.com

**Components**:

• **Prod-Server** (t3.xlarge): Runs frontend and backend in Docker.

• **prod-kafka-server** (t3a.medium): Processes messages/notifications.

• **Amazon RDS** (PostgreSQL 16.3): Production database (db.t3.medium)

• **ElastiCache** Redis: Shared with Dev.

• **prod-kibana-server** (t3.large): Used to monitor logs.

• **ElasticSearch**: Stores application logs.

• **S3 Bucket** (palipoint-prod): Static frontend files

• **CloudFront** : Delivers content efficiently to users

### 3.CI/CD (GitLab)

**Domain**: gitlab.palipoint.com

**Components**:

• **GitLab Server** (t3a.xlarge): Hosts repositories and CI/CD pipelines

• **ECR** (Elastic Container Registry): Stores built Docker images

### Security

**AWS Secrets Manager**: Securely stores database credentials, tokens, and sensitive config


## Application Functionaliy.
   
1. User visits www.palipoint.com or www.palipoint.in
    
2. DNS resolves to public IP → handled via CloudFront
    
3. CloudFront fetches static files from S3 Bucket (frontend)
    
4. Frontend loads in browser and calls backend API
    
5. Backend API (Docker) performs:
    
    ◦ DB operations using RDS PostgreSQL

    ◦ Caching with Redis
    
    ◦ Sends messages to Kafka (notifications)
        
    ◦ Logs events to ElasticSearch

6. Kafka containers process background jobs
    
7. Logs are visualized in Kibana (production only)

## CI/CD Workflow
  
1. Developer pushes code to GitLab (gitlab.palipoint.com)

2. GitLab CI/CD pipeline runs:

   ◦ Code is built into Docker images for palipoint-fe, palipoint-be, and palipoint-notification

   ◦ Images pushed to ECR

   ◦ Deployment triggered to respective servers (Dev or Prod)

 3. Secrets Manager provides secure credentials during deployments

## Data Flow Summary

User → DNS → CloudFront → S3 (frontend files) → Browser (loads app) → Backend API → RDS / Redis / Kafka / ElasticSearch → Kibana (for logs & monitoring)


    



