# 1.JasperReports Server 

JasperReports Server is a tool that helps to **create, share, and manage reports** about the data. It's like a smart report maker that works in a web browser.

- **Show reports online** – You can view and run reports from your web browser.

- **Download reports** – You can export reports as PDF, Excel, Word, or other files.

- **Schedule reports** – You can set it to send reports automatically (like every morning or weekly).

- **Make dashboards** – You can combine different charts and reports into one screen.

- **Control who sees what** – You can decide which users can see or edit reports.

- **Connect to databases** – It pulls data from systems like MySQL, Oracle, PostgreSQL, etc.

- **Embed into other apps** – Developers can put reports inside other websites or systems.

It comes in two main versions:

-    Community Edition (free) — basic features

-    Commercial Edition (paid) — has extras like dashboards, audit logs, multi-org support, etc.

## Requirements for JasperReports Server on Azure Kubernetes Service (AKS)

- Azure account.

- Azure Kubernetes Service (AKS) cluster.

- kubectl installed to manage Kubernetes.

- Docker to build and manage containers.

- Helm (optional, but makes app deployment easier).

- JasperReports WAR file package (from Jaspersoft site)

- A database (like PostgreSQL, MySQL, or SQL Server) either on Azure or inside AKS.

## Plan

1.Create and connect to the AKS Cluster.

2.Download JasperReports Server WAR file package.

3.Create a Docker image with JasperReports Server + Tomcat

4.Create a PostgreSQL (or MySQL) instance, and prepare it for JasperReports

5.Use YAML to deploy the app (Tomcat + JasperReports WAR) to AKS.

6.Use a LoadBalancer or Ingress to allow access from the internet.

7.View JasperReports in Browser.

## Pre-Requisites

- Install tools: Docker, kubectl, Azure CLI, Helm

- Create AKS cluster on Azure

- Download the WAR distribution (JasperReports Server .war package)

- Build Docker image with Tomcat + JasperReports WAR

- Prepare the default_master.properties file to connect to the database

- Test the connection to database

- Create Kubernetes YAMLs (or Helm charts) for:

   - JasperReports deployment

   - Service (LoadBalancer or Ingress)

   - ConfigMap or Secret (for database credentials)

## Design 


  User's Browser
      
   |
   
 LoadBalancer / Ingress               <----------- Exposes JasperReports
    
   |
   

JasperReports Pod                <----------- Runs Docker container

(Tomcat + jasperserver.war) 

   |
   

PostgreSQL / MySQL DB           <-- Hosted in Azure or as Pod in AKS

(holds report data, users)






## Step 1: Prerequisites

Make sure you have these installed:

- Minikube – runs Kubernetes locally

- kubectl – CLI to interact with Kubernetes

- Docker – builds & pulls container images

Check with:
```
minikube version
kubectl version --client
docker --version
```
## Step 2: Start Minikube
```
minikube start
```
This will create a local Kubernetes cluster.

## Step 3: Enable Ingress (optional but useful)
```
minikube addons enable ingress
```
This allows you to access JasperReports through a friendly URL (or just use service port).

## Step 4: Deploy PostgreSQL as the database

1.Create a file postgres-deployment.yaml:

```
nano postgres-deployment.yaml
```
```
apiVersion: v1
kind: Service
metadata:
  name: postgres
spec:
  type: ClusterIP
  ports:
    - port: 5432
  selector:
    app: postgres
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres
spec:
  replicas: 1
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
        - name: postgres
          image: postgres:13
          env:
            - name: POSTGRES_DB
              value: jasperdb
            - name: POSTGRES_USER
              value: jasper
            - name: POSTGRES_PASSWORD
              value: jasper123
          ports:
            - containerPort: 5432

```
2.Apply it:
```
kubectl apply -f postgres-deployment.yaml
```
## Step 5: Deploy JasperReports Server

1.Create a file jasper-deployment.yaml: 

```
nano jasper-deployment.yaml
```
```
apiVersion: v1
kind: Service
metadata:
  name: jasperreports
spec:
  type: NodePort
  ports:
    - port: 8080
      targetPort: 8080
      nodePort: 30080
  selector:
    app: jasperreports
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jasperreports
spec:
  replicas: 1
  selector:
    matchLabels:
      app: jasperreports
  template:
    metadata:
      labels:
        app: jasperreports
    spec:
      containers:
        - name: jasperreports
          image: bitnami/jasperreports:latest
          ports:
            - containerPort: 8080
          env:
            - name: JASPERREPORTS_DATABASE_TYPE
              value: postgresql
            - name: JASPERREPORTS_DATABASE_HOST
              value: postgres
            - name: JASPERREPORTS_DATABASE_PORT_NUMBER
              value: "5432"
            - name: JASPERREPORTS_DATABASE_NAME
              value: jasperdb
            - name: JASPERREPORTS_DATABASE_USER
              value: jasper
            - name: JASPERREPORTS_DATABASE_PASSWORD
              value: jasper123
            - name: JASPERREPORTS_USERNAME
              value: jasperadmin
            - name: JASPERREPORTS_PASSWORD
              value: jasperadmin

```
2. Apply it:
```
kubectl apply -f jasper-deployment.yaml
``` 
