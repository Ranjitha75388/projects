# Palipoint Application - AWS Infrastructure and Design Documentation

   This document provides a overview of the cloud architecture and application design of the Palipoint system. 

## AWS Region & Networking

### 1.AWS Region

   All resources are deployed in Asia Pacific (Mumbai) - ap-south-1.

### 2.VPCs and Subnets

The infrastructure includes three separate Virtual Private Clouds (VPCs):
   
 1. Default VPC – for Non-Production (Dev/QA)
    
 2. prod-vpc – for Production
    
 3. Palipoint-VPC – for CI/CD operations (GitLab)

Each VPC contains public subnets where services are deployed.

## Environments

### 1. Non-Production (Dev/QA)

**Domain:** www.palipoint.in

**Components:**

- Dev-QA-Server (t3a.large): Runs Docker containers for:
   
   ◦ Frontend
   
   ◦ Backend

- Dev-Kafka-Server (t3a.small): Notification processing via Kafka

- Amazon RDS (PostgreSQL 15.8): Application database (db.t3.micro)

- ElastiCache Redis (Serverless 7.1): For caching

- ElasticSearch: Application logging and searching

- S3 Bucket (palipoint-dev): Hosts static frontend assets

- CloudFront Distribution: Speeds up asset delivery from S3

### 2.Production

Domain: www.palipoint.com

Components:

• Prod-Server (t3.large): Runs Docker containers for:

  ◦ Frontend
  
  ◦ Backend

• prod-kafka-server (t3.medium): Kafka-based notification processing

• Amazon RDS (PostgreSQL 16.3): Production database (db.t3.medium)

• ElastiCache Redis: Shared with Dev for optimized use

• prod-kibana-server (t3.large): Kibana instance to monitor logs

• ElasticSearch: Centralized logging

• S3 Bucket (palipoint-prod): Static frontend files

• CloudFront Distribution: Delivers content efficiently to users

### 3.CI/CD (GitLab)

Domain: gitlab.palipoint.com

Components:

• GitLab Server (t3a.xlarge): Hosts repositories and CI/CD pipelines

• ECR (Elastic Container Registry): Stores built Docker images

• GitLab Pipelines: Automate build, test, and deployment

## Application Functionality (User Perspective)
   
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

## Developer Workflow (CI/CD)
  
1. Developer pushes code to GitLab (gitlab.palipoint.com)

2. GitLab CI/CD pipeline runs:

   ◦ Code is built into Docker images

   ◦ Images pushed to ECR

   ◦ Deployment triggered to respective servers (Dev or Prod)

 3. Secrets Manager provides secure credentials during deployments

## Data Flow Summary
Frontend (React/HTML) → CloudFront → S3 Bucket → API Calls → Backend Container → RDS (PostgreSQL), Redis, Kafka, ElasticSearch
Logs and performance data → ElasticSearch → Kibana Dashboard

7. Security
    • AWS Secrets Manager: Securely stores database credentials, tokens, and sensitive config
    • Public Subnets: All servers are in public subnets; proper security groups and IAM policies are assumed to be configured

8. Monitoring & Observability
    • ElasticSearch stores application logs
    • Kibana (production only) provides a UI to search/view logs
    • Kafka logs are accessible from Docker logs

9. Conclusion
This architecture supports a scalable, CI/CD-enabled cloud application, with clear separation of Dev and Prod environments. It uses modern AWS services like RDS, ElastiCache, Kafka, S3, CloudFront, and GitLab CI/CD to ensure secure, fast, and reliable deployments.
