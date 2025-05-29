# GCP 
Google Cloud Platform (GCP) is a powerful suite of cloud computing services provided by Google, enabling individuals and organizations to build, deploy, and manage workloads on Google's robust and scalable infrastructure.

### Key Services

-   **Compute**: Run virtual machines (VMs) for various applications.
-    **Networking**: Create and manage Virtual Private Clouds (VPCs) for secure internal networks.
-    **Storage**: Utilize buckets for scalable and durable object storage.
-    **Databases**: Leverage managed database solutions for structured data.
-    **AI/ML**: Access advanced tools for artificial intelligence and machine learning.

### Basic Architecture diagram 
```
+--------------------+
|     Internet       |
+---------+----------+
          |
          | (Ingress SSH/HTTP)
          |
   +------v-------+
   |     VPC      |
   | 10.0.0.0/16  |
   +---+---+---+--+
       |   |   |
       |   |   +-------------------------------+
       |   |                                   |
       |   |                                   |
       |   |                         +---------v---------+
       |   |                         |   Cloud Router    |
       |   |                         +---------+---------+
       |   |                                   |
       |   |                         +---------v---------+
       |   |                         |     Cloud NAT     |
       |   |                         |    (egress only)  |
       |   |                         +---------+---------+
       |   |                                   |
       |   |                         +---------v---------+
       |   |                         |   Private Subnet   |
       |   |                         |     10.0.2.0/24    |
       |   |                         +---------+---------+
       |   |                                   |
       |   |                         +---------v---------+
       |   |                         |    Private VM     |
       |   |                         |   Ext IP: No      |
       |   |                         |   Int IP: 10.0.2.10|
       |   |                         +---------+---------+
       |   |                                   |
       |   |                         Connect via internal IP
       |   |                                   |
       |   |                         +---------v---------+
       |   |                         |     DB Subnet     |
       |   |                         |     10.0.3.0/24    |
       |   |                         +---------+---------+
       |   |                                   |
       |   |                         +---------v---------+
       |   |                         |   Cloud SQL DB    |
       |   |                         |   Int IP only     |
       |   |                         |    10.0.3.10      |
       |   |                         +-------------------+
       |   |
       |   +---------------------------+
       |                               |
       |                               |
       |                   +-----------v-----------+
       |                   |    Public Subnet       |
       |                   |     10.0.1.0/24        |
       |                   +-----------+-----------+
       |                               |
       |                   +-----------v-----------+
       |                   |      Public VM         |
       |                   |    Ext IP: Yes         |
       |                   |    Int IP: 10.0.1.10   |
       |                   +------------------------+
       |
       |                   +------------------------+
       |                   |      VPN Gateway       |
       |                   +-----------+------------+
       |                               |
       |                   +-----------v------------+
       |                   |      VPN Tunnel        |
       |                   +-----------+------------+
       |                               |
       +------------------+------------+------------+
                          |   BGP Session           |
                          |  (Dynamic Routing)     |
                          +------------+------------+
                                       |
                           +-----------v------------+
                           |    External Network    |
                           |      (e.g., AWS)       |
                           +------------------------+
```

### Prerequisites

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
-  After install, run in terminal:
```
 gcloud init
```

##  Resource Setup
### 1. VPC (Virtual Private Cloud)
   
#### What is it?

- A VPC is like a private, isolated network in GCP where you can launch resources like VMs, databases, and GKE clusters. It’s similar to having your own private data center in the cloud.
#### How does it work?

-  You define an IP range for the VPC (e.g., 10.0.0.0/16), and all resources inside it can communicate securely.
-  You can create subnets within the VPC for better organization and security.
-  It isolates your resources from other GCP projects and the public internet unless explicitly allowed.

### Steps to Create in Console:

- In console > Search VPC networks
- Click Create VPC Network.
- Fill in:
  - **Name**: ranjitha-tf-vpc.
  - **Subnet creation mode**: Custom (to manually define subnets).
  - **Dynamic routing mode**: Regional.
-  Click Create.

### 2. Subnets
#### What are they?

Subnets are smaller networks within your VPC, each with its own IP range and region. They help organize resources and control access.
#### How do they work?

- Each subnet has a specific IP range (e.g., 10.0.1.0/24) and is tied to a region (e.g., us-central1).
- Resources in a subnet can communicate with each other directly.

#### Types:

- **Public Subnet**: Resources can have external IPs and be accessed from the internet.
- **Private Subnet**: Resources have no external IPs and can only communicate internally or via NAT.

### Steps to Create in Console:

After creating the VPC, you’ll be prompted to add subnets (or go to the VPC details and click Add Subnet).
- Public Subnet:
   - **Name**: public-subnet
   - **Region**: us-central1
   - **IP range**: 10.0.1.0/24
   - **Private Google Access**: Off (not needed for public subnet)
- Private Subnet:
   - **Name**: private-subnet
   - **Region**: us-central1
   - **IP range**: 10.0.2.0/24       
   - **Private Google Access**: On (required for accessing Google APIs from private VMs)
- Database Subnet:
   - **Name**: db-subnet
   - **Region**: us-central1
   - **IP range**: 10.0.3.0/24
   - **Private Google Access**: On
- Click Create.

### 3. Firewall Rules

#### What are they?

- Firewall rules control what traffic is allowed to enter or leave your VPC. They act like security guards for your network.
#### How do they work?

- Rules are applied based on IPs, ports, protocols, and tags.
- By default, GCP blocks all ingress (incoming) traffic and allows all egress (outgoing) traffic.
- You create rules to allow specific traffic, like SSH (port 22) or HTTP (port 80).

### Steps to Create in Console:

- Go to VPC network > Firewall in the GCP Console.

1. Allow SSH to Public VM (from internet):
 - **Name**: allow-ssh-public
 - **Network**: ranjitha-tf-vpc
 - **Priority**: 1000
 - **Direction of traffic**: Ingress
 - **Action on match**: Allow
 - **Targets**: Specified target tags
 - **Target tags**: public-vm
 - **Source filter**: IPv4 ranges
 - **Source IPv4 ranges**: 0.0.0.0/0 (internet)
 - **Protocols and ports**: TCP: 22
 - **Logs**: Off
 - Click Create.

2. Allow HTTP to Public VM (from internet):
 -  **Name**: allow-http-public
 - **Network**: ranjitha-tf-vpc
 -  **Priority**: 1001
 -  **Direction of traffic**: Ingress
 -  **Action on match**: Allow
 -  **Targets**: Specified target tags
 -  **Target tags**: public-vm
 -  **Source filter**: IPv4 ranges
 -  **Source IPv4 ranges**: 0.0.0.0/0
 -  **Protocols and ports**: TCP: 80
 -  **Logs**: Off
 -  Click Create.

3. Allow Internal Communication (Public <-> Private VM):
 - **Name**: allow-internal
 - **Network**: ranjitha-tf-vpc
 - **Priority**: 1002
 - **Direction of traffic**: Ingress
 - **Action on match**: Allow
 - **Targets**: All instances in the network
 - **Source filter**: IPv4 ranges
 - **Source IPv4 ranges**: 10.0.0.0/16 (VPC range)
 - **Protocols and ports**: All
 - **Logs**: Off
 - Click Create.

4. Allow Private VM to Cloud SQL (MySQL):(**Optional** refer:3 Targets: All instances in the network.so not necessary.)

- **Name** : allow-mysql-access
- **Network** : ranjitha-tf-vpc
- **Direction** :Ingress
- **Action** :Allow
-  **Source IP ranges** :10.0.0.0/24 (your private VM subnet)
-  **Target IP ranges** :10.127.0.4/32 (your Cloud SQL IP)
-  **Protocols and Ports** :tcp:3306


### 4. Cloud Router
#### What is it?

- A Cloud Router is a service in GCP that helps manage network routes dynamically, especially for hybrid connectivity (e.g., connecting GCP to AWS).
#### How does it work?

- It uses BGP (Border Gateway Protocol) to advertise routes between networks.
- It’s required for Cloud NAT to allow private VMs to access the internet.

### Steps to Create in Console:

- Go to Hybrid Connectivity > Cloud Routers in the GCP Console.
- Click Create Router.
- Fill in:
  - **Name**: my-router
  - **Region**: us-central1
  - **Network**: ranjitha-tf-vpc
  - **Google ASN**: 64514 (a unique number for BGP routing)
-   Click Create.

### 5. Cloud NAT (Network Address Translation)

#### What is it?

- Cloud NAT allows VMs in a private subnet to access the internet (e.g., to download updates) without being accessible from the internet.
#### How does it work?

- It translates the private IP of your VM to a public IP for outbound traffic.
- Inbound traffic from the internet is blocked, keeping the VM secure.

### Steps to Create in Console:

- Go to VPC network > Cloud NAT in the GCP Console.
- Click Create NAT Gateway.
- Fill in:
  - **Name**: my-nat
  - **Region**: us-central1
  - **Router**: my-router
  - **Subnet**: private-subnet
  - **External IP**: Auto (GCP will assign a public IP)
-  Click Create.

### 6. VM (Compute Engine)
#### What is it?

- A VM (Virtual Machine) is a computer hosted in the cloud. It can run applications, host websites, or act as a bastion host.
#### How does it work?

- You choose the operating system, machine type (e.g., CPU and memory), and network settings.
- VMs can have external IPs (public) or be internal-only (private).

### Steps to Create in Console:

- Go to Compute Engine > VM instances in the GCP Console.
- Click Create Instance.

1. Public VM:
- **Name**: public-vm
- **Region**: us-central1
- **Zone**: us-central1-a
- **Machine type**: e2-micro
- **Boot disk**: Debian (default)
- **Firewall**: Check "Allow HTTP" and "Allow SSH"
- **Networking** > Network interfaces:
  - **Network**: ranjitha-tf-vpc
  - **Subnet**: public-subnet
  - **External IP**: **Ephemeral** (assigns a temporary public IP)
  - **Network tags**: public-vm
- Click Create.

2. Private VM:
- **Name**: private-vm
- **Region**: us-central1
- **Zone**: us-central1-a
- **Machine type**: e2-micro
- **Boot disk**: Debian (default)
- **Firewall**: No options needed
- **Networking** > Network interfaces:
  - **Network**: ranjitha-tf-vpc
  - **Subnet**: private-subnet
  - **External IP**: **None**
- Click Create.

### 7. Private Service Access
#### What is it?

- Private Service Access allows your VPC to connect to Google services (like Cloud SQL) using private IPs, keeping communication internal and secure.
#### How does it work?

- You allocate an IP range for Google services.
- GCP creates a private connection between your VPC and Google services using this range.

### Steps to Create in Console:

1. Allocate IP Range:
- Go to VPC network > VPC networks in the GCP Console.
- Click on ranjitha-tf-vpc.
- In the left menu, click Private service connection.
- Click Allocate IP range.
- Fill in:
  - **Name**: private-service-ip
  - **Region**: us-central1
  - **IP range**: 10.10.0.0/16 (must not overlap with VPC subnets)
- Click Allocate.
 
2.Create Private Connection:
- On the same page, click Create connection.
- Select:
  - Connected service provider: Google Cloud Platform
  - Allocated allocation: private-service-ip
- Click Create connection.

### 8. Cloud SQL with Private IP
#### What is it?

- Cloud SQL is a managed database service in GCP (e.g., MySQL, PostgreSQL). Using a private IP ensures it’s only accessible within your VPC.
#### How does it work?

- You create a database instance and assign it a private IP.
- It can only be accessed by resources in your VPC (e.g., private VM).

### Steps to Create in Console:

- Go to SQL > Create Instance in the GCP Console.
- Choose MySQL.
- Fill in:
  - **Edition Preset**: Production
  - **Database Version**: MySQL 8.0
  - **Instance ID**: gcp-mysql-db
  - **Root Password**: StrongP@ssword123!
  - **Region**: us-central1
  - **Zonal Availability**: Multiple zones (Highly Available)
  - **Machine Type**: N2 - 4 vCPU, 32 GB RAM
  - **Storage Type**: SSD
  - **Storage Capacity**: 250 GB
  - **Enable Automatic Storage Increases**: Yes
  -   Networking:
    - **IP Assignmen**t: Private IP
    - **VPC Network**: ranjitha-tf-vpc
    - **Private Services Access**: Enabled
    - **No Public IP**: Yes (for security)
    - **Authorized Networks**: Enable (for SQL Proxy or private access)
- Click Create Instance.
- Note the private IP (e.g., 10.0.3.10) assigned to the Cloud SQL instance.

#### Test Connection:

- From the private VM, connect to Cloud SQL:
```
mysql -h 10.0.3.10 -u root -p
```
- Enter the password (StrongP@ssword123!) when prompted.

### 9. Artifact Registry
#### What is it?

- Artifact Registry is a storage service in GCP for software artifacts like Docker images, Maven packages, or npm packages.
#### How does it work?

- You create a repository to store artifacts.
- You can push artifacts (e.g., Docker images) to the repository and pull them for deployments.

### Steps to Create in Console:

- Go to Artifact Registry > Create Repository in the GCP Console.
- Fill in:
  - **Name**: my-docker-repo
  - **Format**: Docker
  - **Mode**: Standard
  - **Location Type**: Region
  - **Region**: us-central1
  - **Description**: "Docker images for my app"
- Click Create.

- #### Configure Docker to push/pull images:
```    
 gcloud auth configure-docker us-central1-docker.pkg.dev
```
- #### Push a Docker image:
```
 docker tag my-image:latest us-central1-docker.pkg.dev/my-first-gcp-project/my-docker-repo/my-image:latest
 docker push us-central1-docker.pkg.dev/my-first-gcp-project/my-docker-repo/my-image:latest
```
### 10. GKE (Google Kubernetes Engine) Standard Cluster

#### What is it?
- GKE is a managed Kubernetes service in GCP for running containerized applications.
- A **Standard Cluster** gives you full control over the nodes (VMs).
- A **autopilot cluster** managed by google.

#### How does it work?

- GKE creates a Kubernetes cluster with a control plane (managed by GCP) and worker nodes (VMs you configure).
- You deploy containerized applications (e.g., Docker images) to the cluster.

### Steps to Create in Console:

- Go to Kubernetes Engine > Clusters in the GCP Console.
- Click Create and choose Standard.
- Fill in:
  - **Cluster name**: drip-nonprod
  - **Location**: Zonal, us-central1-a
  - **Networking mode**: VPC-native
  - **VPC**: ranjitha-tf-vpc
  - **Subnetwork**: private-subnet
  - **Node pool**:
    - **Machine type**: e2-medium
    - **Nodes**: 1 (for nonprod)
  - Click Create.

#### Authenticate kubectl:
```
 gcloud container clusters get-credentials drip-nonprod --zone us-central1-a --project my-first-gcp-project
```
#### Deploy a sample app: Create a deployment.yaml:
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: react-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: react-app
  template:
    metadata:
      labels:
        app: react-app
    spec:
      containers:
      - name: react-app
        image: us-central1-docker.pkg.dev/my-first-gcp-project/my-docker-repo/my-image:latest
        ports:
        - containerPort: 80
```
- Apply it:
```
kubectl apply -f deployment.yaml
```
- Expose the app:
```
 kubectl expose deployment react-app --type=LoadBalancer --port=80 --target-port=80
 kubectl get service
```
    
### 11. Connect GCP to AWS Using a VPN Gateway

### Step 1:VPN Gateway
#### What is it?

- A Cloud VPN Gateway in GCP is a resource that enables secure communication between your GCP VPC and AWS VPC using an IPsec VPN over the internet.

### Steps in console

- Go to Hybrid Connectivity > VPN.
- Create a VPN Connection:
   - Click Create VPN Connection.
   - Choose Classic VPN (simpler for this setup; use HA VPN for high availability if needed).
 - Configure the VPN Gateway:
    - **Name**: gcp-to-aws-vpn-gateway
    - **Network**: ranjitha-tf-vpc
    - **Region**: us-central1
    - **IP address**: Create a new static IP
    - Click Reserve a new static IP address.
      - **Name**: gcp-vpn-ip
    - Click Reserve.
    - Leave other settings as default for now.
 - Save and Continue:
 - Note the public IP address assigned to the GCP VPN Gateway (e.g., 35.200.100.10). You’ll need this for the AWS side.

### Step 2: Create a Cloud Router in GCP (for BGP)
#### What is it?

- A Cloud Router in GCP manages dynamic routing (using BGP) between your GCP VPC and AWS VPC. It’s required for dynamic routing and will also be used later for the VPN tunnels.
### Steps in console

- Navigate to Hybrid Connectivity > Cloud Routers.
- Click Create Router.
- Configure the Cloud Router:
  - **Name**: gcp-to-aws-router
  - **Network**: ranjitha-tf-vpc
  - **Region**: us-central1
  - **Google ASN**: 64514 (a unique number for BGP; note this for AWS setup)
  -  Leave other settings as default.
- Click Create.

### Step 3: Create a Peer VPN Gateway in GCP
#### What is it?

- A Peer VPN Gateway in GCP represents the AWS VPN gateway. It tells GCP where to send VPN traffic (i.e., the public IP of the AWS VPN gateway).

### Steps in coonsole

- Go back to Hybrid Connectivity > VPN.
- Select gcp-to-aws-vpn-gateway.
- Scroll to Peer VPN Gateways.
- Click Add Peer VPN Gateway.
- Configure the Peer VPN Gateway:
   - **Name**: aws-peer-vpn-gateway
   - **Interfaces**: Add two interfaces (AWS provides two tunnels for redundancy):
      - Interface 0 IP address: 203.0.113.10 (AWS VPN gateway’s first tunnel IP; placeholder for now, you’ll update this after AWS setup).
      - Interface 1 IP address: 203.0.113.11 (AWS VPN gateway’s second tunnel IP; placeholder for now).
    - Save:
- Cick Save.
- You’ll update these IPs after setting up the AWS side.

### Step 4: Create VPN Tunnels in GCP
#### What is it?

- VPN Tunnels are the encrypted connections between the GCP VPN Gateway and the AWS VPN Gateway. AWS provides two tunnels for redundancy, so we’ll create two tunnels in GCP.

### Steps in console
- Add the First Tunnel:
- In the VPN setup page for gcp-to-aws-vpn-gateway, scroll to Tunnels.
- Click Add Tunnel.
- Configure the First Tunnel:
  - **Name**: gcp-to-aws-tunnel-1
  - **VPN Gateway**: gcp-to-aws-vpn-gateway
  - **Peer VPN Gateway**: aws-peer-vpn-gateway
  - **Interface**: 0 (corresponds to Interface 0 IP 203.0.113.10)
  - **Shared Secret**: 8J2kP9mWqL5xN3vR7tY1uI4oE6gH8jK9lM2nO4pQ6rS8tU0vW2xY4zA6bC8dE0f (generate a secure key and note it down)
  - **Remote Peer IP Address**: 203.0.113.10 (placeholder; update later)
  - **IKE Version**: IKEv2 (recommended)
  - **Routing Type**: Dynamic (BGP)
  - **Cloud Route**r: gcp-to-aws-router
- Click Create.
- Add the Second Tunnel:
- Click Add Tunnel again.
  - **Name**: gcp-to-aws-tunnel-2
  - **VPN Gateway**: gcp-to-aws-vpn-gateway
  - **Peer VPN Gateway**: aws-peer-vpn-gateway
  - **Interface**: 1 (corresponds to Interface 1 IP 203.0.113.11)
  - **Shared Secret**: DifferentKeyForTunnel2_1234567890abcdef (use a different key for the second tunnel)
  - **Remote Peer IP Address**: 203.0.113.11 (placeholder; update later)
  - **IKE Version**: IKEv2
  - **Routing Type**: Dynamic (BGP)
  - **Cloud Router**: gcp-to-aws-router
- Click Create.

### Step 5: Configure BGP Sessions in GCP
#### What is it?

- BGP (Border Gateway Protocol) allows your GCP VPC and AWS VPC to dynamically exchange routes, so resources in both networks can communicate seamlessly.

### Steps in console

- Navigate to Hybrid Connectivity > Cloud Routers.
- Click on gcp-to-aws-router.
- Add BGP Session for the First Tunnel:
- Under BGP Sessions, click Add BGP Session.
   - **Name**: gcp-to-aws-bgp-1
   - **Peer ASN**: 65001 (AWS default ASN; confirm this in AWS later)
   - **Peer IP Address**: 169.254.1.2 (AWS side BGP IP)
   - **Cloud Router IP Address**: 169.254.1.1 (GCP side BGP IP)
   - **Advertised Route Priority**: 100
 - Click Save.
 - Add BGP Session for the Second Tunnel:
 - Click Add BGP Session again.
   - **Name**: gcp-to-aws-bgp-2
   - **Peer ASN**: 65001
   - **Peer IP Address**: 169.254.2.2 (AWS side BGP IP for second tunnel)
   - **Cloud Router IP Address**: 169.254.2.1 (GCP side BGP IP)
   - **Advertised Route Priority**: 100
 - Click Save.

### Step 6: Configure the AWS Side

Now, set up the VPN connection in AWS to connect to the GCP VPN Gateway.
AWS prerequesties Setup:

- An AWS account.
- An AWS VPC (e.g., aws-vpc) with CIDR 172.31.0.0/16.
- A subnet in AWS (e.g., aws-subnet at 172.31.1.0/24).
- An EC2 instance in the subnet for testing (e.g., at 172.31.1.10).
  
#### Step 6.1: Create a Customer Gateway in AWS

- Go to VPC > Customer Gateways.
- Create Customer Gateway:
- Click Create Customer Gateway.
  - Name: gcp-customer-gateway
  - BGP ASN: 64514 (match GCP’s ASN)
  - IP Address: 35.200.100.10 (GCP VPN Gateway’s public IP)
- Click Create Customer Gateway.

#### Step 6.2: Create a Virtual Private Gateway in AWS

- Navigate to VPC > Virtual Private Gateways.
- Click Create Virtual Private Gateway.
- Configure Virtual Private Gateway:
   - **Name**: aws-vgw
   - Click Create Virtual Private Gateway.
   - Attach it to your AWS VPC:
     - Select the VGW, click Actions > Attach to VPC.
     - Choose your AWS VPC (aws-vpc).
- Enable Route Propagation:
- Go to VPC > Route Tables.
- Select the route table for your AWS VPC.
- Click Route Propagation > Edit Route Propagation.
- Enable propagation for aws-vgw.

#### Step 6.3: Create a Site-to-Site VPN Connection in AWS

- Navigate to VPC > Site-to-Site VPN Connections.
- Click Create VPN Connection.
- Configure the VPN Connection:
  - **Name**: aws-to-gcp-vpn
  - **Target Gateway Type**: Virtual Private Gateway
  - **Virtual Private Gateway**: aws-vgw
  - **Customer Gateway**: Existing
  - Select gcp-customer-gateway.
  - Routing Options: Dynamic (BGP)
  - Tunnel Options:
     - Tunnel 1 Pre-shared Key: 8J2kP9mWqL5xN3vR7tY1uI4oE6gH8jK9lM2nO4pQ6rS8tU0vW2xY4zA6bC8dE0f (match GCP’s first tunnel)
     - Tunnel 1 Inside IP Addresses:
     - Customer Gateway (GCP): 169.254.1.1/30
     - Virtual Private Gateway (AWS): 169.254.1.2/30
     - Tunnel 2 Pre-shared Key: DifferentKeyForTunnel2_1234567890abcdef (match GCP’s second tunnel)
     - Tunnel 2 Inside IP Addresses:
     - Customer Gateway (GCP): 169.254.2.1/30
     - Virtual Private Gateway (AWS): 169.254.2.2/30
- Click Create VPN Connection.
- Download Configuration:
- Select the VPN connection (aws-to-gcp-vpn).
- Click Download Configuration.
- Choose Generic as the vendor.
- Note the Outside IP Addresses for the AWS VPN gateway:
     - Tunnel 1: 203.0.113.10 (example)
     - Tunnel 2: 203.0.113.11 (example)

#### Step 6.4: Update GCP Peer VPN Gateway with AWS IPs

- Go Back to GCP:
- Navigate to Hybrid Connectivity > VPN.
- Select gcp-to-aws-vpn-gateway.
- Edit the Peer VPN Gateway (aws-peer-vpn-gateway).
- Update IPs:
   - Interface 0 IP address: 203.0.113.10 (AWS Tunnel 1 IP)
   - Interface 1 IP address: 203.0.113.11 (AWS Tunnel 2 IP)
   - Click Save.
- Update VPN Tunnels:
   - Edit gcp-to-aws-tunnel-1:
     Remote Peer IP Address: 203.0.113.10
   - Edit gcp-to-aws-tunnel-2:
     Remote Peer IP Address: 203.0.113.11
- Click Save for each tunnel.

### Step 8: Configure Firewall Rules and Security Groups
### In GCP:
1.Allow Traffic from AWS VPC:
- Go to VPC network > Firewall.
- Click Create Firewall Rule.
- Name: allow-gcp-to-aws
- Network: ranjitha-tf-vpc
- Direction: Ingress
- Action: Allow
- Targets: All instances in the network
- Source IPv4 ranges: 172.31.0.0/16 (AWS VPC CIDR)
- Protocols and ports: All
- Click Create.
2. Allow VPN Traffic:
- Create another rule:
- Name: allow-vpn-traffic
- Network: ranjitha-tf-vpc
- Direction: Ingress
- Action: Allow
- Source IPv4 ranges: 203.0.113.10, 203.0.113.11 (AWS VPN IPs)
- Protocols and ports: UDP: 500 (IKE), Protocol 50 (ESP)
- Click Create.

### In AWS:

- Update Security Group for the EC2 Instance:
-  Go to EC2 > Security Groups.
- Select the security group for your EC2 instance.
- Add an inbound rule:
- Type: All Traffic
- Source: 10.0.0.0/16 (GCP VPC CIDR)
- Save.
- Update Network ACLs (if needed):
- Go to VPC > Network ACLs.
- Select the NACL for your AWS VPC.
- Add inbound and outbound rules:
- Allow traffic from 10.0.0.0/16 on all ports.

### Step 9: Test the VPN Connection

1. Check VPN Tunnel Status in GCP:
  - Go to Hybrid Connectivity > VPN.
  - Select gcp-to-aws-vpn-gateway.
  - Check the status of gcp-to-aws-tunnel-1 and gcp-to-aws-tunnel-2.
  -  Both should show Tunnel Established.
2. Check BGP Status in GCP:
  - Go to Hybrid Connectivity > Cloud Routers.
  - Select gcp-to-aws-router.
  - Check the status of gcp-to-aws-bgp-1 and gcp-to-aws-bgp-2.
  - Both should show BGP Established.
3. Check VPN Status in AWS:
  - Go to VPC > Site-to-Site VPN Connections.
  - Select aws-to-gcp-vpn.
  - Check the status of both tunnels (should be Up).
4. Test Connectivity:
-  From your GCP VM (private-vm at 10.0.2.10):
```
ping 172.31.1.10
(Replace 172.31.1.10 with your AWS EC2 instance’s private IP.)
```
- From your AWS EC2 instance:
```
ping 10.0.2.10
```
If pings fail, check:

- Firewall rules in GCP and security groups in AWS.
- Route tables in both GCP and AWS to ensure routes are propagated.

