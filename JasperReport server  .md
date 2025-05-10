# 1.JasperReports Server 

JasperReports Server is a java based web application tool that helps to **create, share, and manage reports** about the data. It's like a smart report maker that works in a web browser.

- **Creating Reports** – Design tabular and graphical reports.

- **Viewing Reports Online** – Accessible through the browser.

- **Exporting** – Download as PDF, Excel, etc.

- **Scheduling** – Email reports daily/weekly.

- **User Roles** – Control who can create/view/edit reports.

- **Embedding** – Can be embedded in other apps.

- **Database Support** – Connects to PostgreSQL, MySQL, Oracle, and more.

It comes in two main versions:

-    Community Edition (free) - latest version(7.0.2) — basic features

-    Commercial Edition (paid) - latest version(9.0)— has extras like dashboards, audit logs, multi-org support, etc.

## Requirements for JasperReports Server on Azure Kubernetes Service (AKS)

- Azure account.

- Azure container Registry.

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


## Steps to deploying Jasper report server in Azure kubernetes service
 
### Step 1: Prerequisites

- Minikube – runs Kubernetes locally

- kubectl – CLI to interact with Kubernetes

- Docker – builds & pulls container images

 Check with:

```
minikube version
kubectl version --client
docker --version
```
### Step 2: Start Minikube
```
minikube start
```
This will create a local Kubernetes cluster.

### Step 3: Enable Ingress (optional but useful)
```
minikube addons enable ingress
```
This allow to access JasperReports through a friendly URL.

### Step 4: Deploy PostgreSQL as the database

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
### Step 5: Deploy JasperReports Server : 

- Bitnami Docker image used. This image already has the .war file pre-installed and deployed in Tomcat, so no manual download or deployment is required.Latest version:8.2.0


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
### Step 6: Check pods are in running state and service

![image](https://github.com/user-attachments/assets/4dab492b-211e-40bd-9fda-c276fb2faae9)

## Step 7:Access JasperReports in Browser

1.Get the IP:
```
minikube ip
```
2.Access JasperReports using:
```
http://<minikube-ip>:30080
```
3.Log in with:

   - Username: jasperadmin

   - Password: jasperadmin

![Screenshot from 2025-05-09 13-24-24](https://github.com/user-attachments/assets/6011f115-8b93-4a54-b8bb-96f39829219f)

## Step 8:Jasper report server

**Jaspersoft Studio:**

   - Go to the official "Jaspersoft Studio download page"

  - It allows users to create .jrxml files (JasperReports files) that define how the report will look and behave.

  - It allows previewing the design with real data fetched from connected data sources (e.g., databases, web services, etc.).

  - You can create reports with tables, charts, images, text fields, etc.

- It can export reports to various formats like PDF, Excel, HTML, CSV, and more.

**JasperReports Server:**

- After designing reports in Jaspersoft Studio, you can upload them to JasperReports Server.

- .jrxml file must be compiled into a .jasper file before it can be executed by the JasperReports engine (though the JasperReports Server does this automatically upon upload).

- You can execute reports directly from the server, with the option to run reports on-demand or schedule them for regular intervals (e.g., daily, weekly).

- JasperReports Server allows role-based access control, letting administrators manage who can view, edit, or execute specific reports.

 - JasperReports Server provides security features like authentication and authorization, enabling fine-grained control over data access.

1.once logged in

![Screenshot from 2025-05-09 12-36-20](https://github.com/user-attachments/assets/560f6b15-6243-47fb-bcdf-71a98a9a6eb6)

2.After log in navigate to "view" > "Repository".
   - Under Repository right click "Root"
   - "Add folder" - Give folder name (MyReports) and save.
   - Right click "MyReports" > "Add Resourses"


