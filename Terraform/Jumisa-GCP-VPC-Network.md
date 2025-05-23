# GCP

- Google Cloud Platform (GCP) is a cloud computing services by Google that allows individuals and organizations to run and manage workloads on Google's infrastructure.

- It includes services like compute (VMs), networking (VPC), storage (buckets), databases, and more.

- You use GCP to:

  - Run virtual machines (VMs)

  - Host websites

  - Build internal networks

  - Analyze data

  - Use AI/ML services

## Setup Guide

#### Step 1: Create a Google Account

- Go to https://accounts.google.com and create a Google account if you don't already have one.

#### Step 2: Sign Up for Google Cloud

- Go to https://console.cloud.google.com/

- Accept terms and sign in with your Google account.

- You'll be asked to set up a billing account. GCP offers a $300 free credit for 90 days.

#### Step 3: Create a New Project

- In the GCP Console, click the project drop-down (top bar).

- Click "New Project"

- Enter project name: my-first-gcp-project

- Click "Create"

#### Install gcloud CLI (Google Cloud SDK)

- To Download in Linux
```
 curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-451.0.1-linux-x86_64.tar.gz
 tar -xvzf google-cloud-sdk-*.tar.gz
 ./google-cloud-sdk/install.sh
```
- After install, run in terminal:
```
 gcloud init
```
### Understanding GCP Networking Components

#### 1. VPC (Virtual Private Cloud)

- A private, isolated network within GCP.

- We can launch VMs, databases, and connect services within it.

#### 2. Subnets

- Sub-networks within a VPC.

- Each is assigned a specific IP range and region.

#### Types:

  - Public Subnet: Allows VMs to have external IPs (internet-facing).

  - Private Subnet: No external IPs. Internal-only communication.

#### 3. Firewall Rules

- Controls what traffic is allowed to/from our network.

- Can be based on IPs, ports, protocols.

#### Default Firewall Rules:

GCP automatically creates the following when a new VPC is made using the default mode:

- **default-allow-icmp**: Allows internal ICMP (ping) traffic.

- **default-allow-internal**: Allows all internal traffic within the 10.128.0.0/9 range.

- **default-allow-rdp**: Allows RDP (Windows) access on TCP port 3389.

- **default-allow-ssh**: Allows SSH access on TCP port 22.

#### When creating a custom VPC, no firewall rules are created. You must define them explicitly.

#### Custom Firewall Rules

GCP blocks all ingress (incoming) traffic by default. You must:

- Allow SSH (port 22) to connect to Linux VMs

- Allow HTTP (port 80) to host websites

- Use internal firewall rules to allow private-to-private communication

- Use tags or service accounts to apply rules to specific VMs

#### 4. Cloud Router

- Handles dynamic route advertisements, especially for hybrid connectivity.

- Required when configuring Cloud NAT.

#### 5. Cloud NAT (Network Address Translation)

- Allows VMs in private subnet to access the internet (e.g., to install packages), but not be accessed from internet.

#### 6. VM (Compute Engine)

- A computer hosted in the cloud.

- Can be public (has external IP) or private (no external IP).

#### 7. Service Account

- Identity that our VM uses to access other GCP services securely.

## Create and Use Service Account

#### What is it?

A Service Account is like a special user your VM or app uses to interact with GCP securely (e.g., access storage, databases).

#### When to Use

Always create a custom service account for better security and control.

#### Steps:

- Go to IAM & Admin > Service Accounts

- Click Create Service Account

- Name: vm-service-account

- Grant Role: Compute Admin or least privilege needed

- Click "Done"

#### Create Key (Download JSON File)

- Go to the service account you just created

- Click on Keys > Add Key > Create New Key

- Select JSON format

- Download the file — this is your credentials file

- Store and Use JSON File Securely

- Store this file securely on your local machine

- Never commit this file to GitHub or share it

#### Use with gcloud CLI:
```
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/your/vm-service-account.json"
```
#### Attach to VM

- When creating a VM:

  - Click Security.

  - Under Identity and API Access, select your service account.



























