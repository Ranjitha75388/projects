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

1.Create a Docker image with JasperReports Server + Tomcat

2.Create a PostgreSQL (or MySQL) instance, and prepare it for JasperReports

3.Use YAML to deploy the app (Tomcat + JasperReports WAR) to Kubernetes.

4.Use a LoadBalancer or Ingress to allow access from the internet.

5.Add TLS (HTTPS), set up users, and apply licensing.


## Pre-Requisites (Before Starting)

- Install tools: Docker, kubectl, Azure CLI, Helm

- Create AKS cluster on Azure

- Download the WAR distribution (JasperReports Server .war package)

- Build Docker image with Tomcat + JasperReports WAR

- Prepare your default_master.properties file to connect to the database

- Test the connection to your database

- Create Kubernetes YAMLs (or Helm charts) for:

   - JasperReports deployment

   - Service (LoadBalancer or Ingress)

   - ConfigMap or Secret (for database credentials)

