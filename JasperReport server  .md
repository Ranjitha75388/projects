# 1.JasperReports Server 

- JasperReports Server is a web-based reporting tool used to create, manage, and share reports.

- It lets users generate reports from databases and view them in a browser.

- Think of it as an online report builder for organizing and presenting data clearly.

#### Essential Functions of JasperReports Server 

   - **Creating Reports** – Design both tabular and graphical reports using JRXML.

   - **Viewing Reports Online** – Access and view reports directly from a web browser.

   - **Exporting** – Download reports as PDF, Excel, Word, etc.

   - **Scheduling** – Automate report delivery by email on a set schedule (daily, weekly, etc.).

   - **User Roles & Permissions** – Manage access control (view/edit/create) for users.

   - **Embedding** – Integrate reports into other web or enterprise applications.

   - **Database Support** – Connects to various databases like PostgreSQL, MySQL, Oracle, and others.

It comes in two main versions:

-    Community Edition (free) - latest version(7.0.2) — basic features

-    Commercial Edition (paid) - latest version(9.0)— has extras like dashboards, audit logs, multi-org support, etc.

## Requirements for JasperReports Server on Azure Kubernetes Service (AKS)

- **Azure Account** – For using AKS, Storage, Registry.

- **AKS Cluster** – A Kubernetes cluster to run JasperReports.

- **Azure Container Registry** – (Optional) To store custom Docker images.

- **kubectl** – To control the cluster.

- **Docker** – To build container images.

- **Helm** (Optional) – For easier deployment.

- **PostgreSQL Database** – Our report data source (inside AKS or Azure).

- **JasperReports Server WAR File** – Web application package.

- **JDBC Driver** – Needed so JasperReports can talk to the database.

- **LoaadBalancer/ Ingress Controller** – JasperReports accessible via a public IP or custom domain.

- **Secrets** – Use Kubernetes Secrets to store DB passwords safely.

- **Persistent Volume** – To store reports/uploads.

- **JasperReports Studio** – (Optional) designing .jrxml reports locally before uploading them to the server.


## Deployment Plan: JasperReports Server on AKS

#### 1. Create and Connect to AKS Cluster

 - Connect using
```
az aks get-credentials and verify with kubectl get nodes.
```
#### 2.Prepare JasperReports WAR Package

-  Download the Community or commercial WAR package from Jaspersoft .

#### 3. Build Docker Image

-  Use a Dockerfile with Tomcat + JasperReports WAR + JDBC driver.

-  Push image to Azure Container Registry (ACR) or Docker Hub.

#### 4.  Deploy PostgreSQL (or other DB) to AKS

-  Use Kubernetes YAML or Helm to deploy PostgreSQL.

-  Set POSTGRES_DB, POSTGRES_USER, and POSTGRES_PASSWORD.


#### 5. Create Secrets and ConfigMaps

  -   Store DB credentials securely using kubectl create secret.

   -  Create ConfigMap for environment variables if needed.

 #### 6. Deploy JasperReports Server to AKS

   -  Create a Kubernetes Deployment yaml.

  -  Mount any required volumes (for persistence/logs).

   - Connect it to the PostgreSQL service using JDBC URL:
```
    jdbc:postgresql://<postgres-service>:5432/<db-name>
```
#### 7.Expose the Application

- Use a LoadBalancer service or configure an Ingress controller (e.g., NGINX).

- Access the JasperReports Server in browser using the external IP.

#### 8. Use JasperReports Server

- Upload .jrxml files, create data sources, and generate reports.

## Pre-Requisites

- **Install Tools**: Docker, kubectl, Azure CLI, and optionally Helm.

-  **Azure Setup**: Create an AKS cluster and optionally an Azure Container Registry (ACR).

- **Download JasperReports WAR**: Get the JasperReports Server WAR file.

- **Build Docker Image**: Tomcat + JasperReports WAR + JDBC Driver
  
- **Database Setup**: Deploy PostgreSQL (Azure or AKS), create a database (jasperdb), and test the connection.

- **Configure:** Edit default_master.properties for DB credentials. Use ConfigMap/Secret for secure storage.

- **Kubernetes YAMLs**: Create YAMLs for:

     -   JasperReports Deployment

     -  Service (LoadBalancer/Ingreess)

     - Secrets for DB credentials

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


## Steps to deploying Jasper report server in kubernetes service
 
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

- Bitnami Docker image used. This image already has the .war file pre-installed and deployed in Tomcat, so no manual download or deployment is required.Latest version:8.2.0 of jasper report server.


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

## Step 8:Upload file in Jasper report server

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

#### 1.once logged in

![Screenshot from 2025-05-09 12-36-20](https://github.com/user-attachments/assets/560f6b15-6243-47fb-bcdf-71a98a9a6eb6)

#### 2.Before entering to next step, Ensure You Have a Table in PostgreSQL

```
kubectl exec -it <postgres-pod-name> -- psql -U jasper -d jasperdb
```
Inside the psql shell:
```
CREATE TABLE employees (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  department VARCHAR(100)
);

INSERT INTO employees (name, department)
VALUES 
  ('Alice', 'HR'),
  ('Bob', 'IT'),
  ('Charlie', 'Finance');
```

#### 3.Create a folder under Repository

- Go to  view > Repository.

- Left side "Root" right click it.

- "Add folder" - Give folder name (MyReports) and save.

#### 4.Create a JDBC Data Source

- Right click  MyReports > Add Resourse > Data Source

 ![image](https://github.com/user-attachments/assets/710f518b-d8cc-45a7-a47a-5bf05360af8f)
 
   
 ![Screenshot from 2025-05-10 21-03-36](https://github.com/user-attachments/assets/f419619f-4ccf-4f2e-982e-3ab168e63b55)


#### 5.Use Valid JRXML File (for employees Table)

```
<?xml version="1.0" encoding="UTF-8"?>
<jasperReport xmlns="http://jasperreports.sourceforge.net/jasperreports"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://jasperreports.sourceforge.net/jasperreports http://jasperreports.sourceforge.net/xsd/jasperreport.xsd"
              name="EmployeeReport" pageWidth="595" pageHeight="842" columnWidth="555"
              leftMargin="20" rightMargin="20" topMargin="20" bottomMargin="20" uuid="12345678-90ab-cdef-1234-567890abcdef">

    <queryString>
        <![CDATA[
            SELECT id, name, department FROM employees
        ]]>
    </queryString>

    <field name="id" class="java.lang.Integer"/>
    <field name="name" class="java.lang.String"/>
    <field name="department" class="java.lang.String"/>

    <title>
        <band height="40">
            <staticText>
                <reportElement x="0" y="0" width="400" height="30"/>
                <textElement>
                    <font size="16" isBold="true"/>
                </textElement>
                <text><![CDATA[Employee Report]]></text>
            </staticText>
        </band>
    </title>

    <columnHeader>
        <band height="20">
            <staticText>
                <reportElement x="0" y="0" width="100" height="20"/>
                <text><![CDATA[ID]]></text>
            </staticText>
            <staticText>
                <reportElement x="100" y="0" width="200" height="20"/>
                <text><![CDATA[Name]]></text>
            </staticText>
            <staticText>
                <reportElement x="300" y="0" width="200" height="20"/>
                <text><![CDATA[Department]]></text>
            </staticText>
        </band>
    </columnHeader>

    <detail>
        <band height="20">
            <textField>
                <reportElement x="0" y="0" width="100" height="20"/>
                <textFieldExpression><![CDATA[$F{id}]]></textFieldExpression>
            </textField>
            <textField>
                <reportElement x="100" y="0" width="200" height="20"/>
                <textFieldExpression><![CDATA[$F{name}]]></textFieldExpression>
            </textField>
            <textField>
                <reportElement x="300" y="0" width="200" height="20"/>
                <textFieldExpression><![CDATA[$F{department}]]></textFieldExpression>
            </textField>
        </band>
    </detail>

</jasperReport>

```
#### 6. Save the JRXML File

  -  Open any text editor (like Notepad, VS Code, or Nano).

  -  Paste the content above.

  -  Save it as: employee_report.jrxml

#### 7. Upload to JasperReports Server

- Go to Repository > Root.

- Click Add Resource > JasperReport.

- Enter a Name,( e.g., **employee**).

- Click Upload a file, browse for employee_report.jrxml from local Downloads.

- In Data Source, choose your PostgreSQL connection created in step-4
   
- Click submit
 
#### 8. Navigate to Repository and Run "employee" file added.

output:

![image](https://github.com/user-attachments/assets/7242dffd-e0dd-4eb0-bf5f-8801e5b00f7a)



