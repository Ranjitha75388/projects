# GCP 
Google Cloud Platform (GCP) is a powerful suite of cloud computing services provided by Google, enabling individuals and organizations to build, deploy, and manage workloads on Google's robust and scalable infrastructure.

### Key Services

-   **Compute**: Run virtual machines (VMs) for various applications.
-    **Networking**: Create and manage Virtual Private Clouds (VPCs) for secure internal networks.
-    **Storage**: Utilize buckets for scalable and durable object storage.
-    **Databases**: Leverage managed database solutions for structured data.
-    **AI/ML**: Access advanced tools for artificial intelligence and machine learning.

### Architecture diagram 

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
### Prerequisites

#### Step 1: Create a Google Account

- Go to https://accounts.google.com and create a Google account if you don't already have one.

#### Step 2: Sign Up for Google Cloud

-    Go to https://console.cloud.google.com/

-    Accept terms and sign in with your Google account.

-    You'll be asked to set up a billing account. GCP offers a $300 free credit for 90 days.

#### Step 3: Create a New Project

-    In the GCP Console, click the project drop-down (top bar).

-    Click "New Project"

-    Enter project name: my-first-gcp-project

-    Click "Create"

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
   
- #### What is it?

    A VPC is like a private, isolated network in GCP where you can launch resources like VMs, databases, and GKE clusters. It’s similar to having your own private data center in the cloud.
- #### How does it work?

  -  You define an IP range for the VPC (e.g., 10.0.0.0/16), and all resources inside it can communicate securely.
  -  You can create subnets within the VPC for better organization and security.
  -  It isolates your resources from other GCP projects and the public internet unless explicitly allowed.

- ### Steps to Create in Console:

  - In console > Search VPC networks
  - Click Create VPC Network.
  -  Fill in:
       - **Name**: ranjitha-tf-vpc.
       - **Subnet creation mode**: Custom (to manually define subnets).
       - **Dynamic routing mode**: Regional.
  -  Click Create.

### 2. Subnets
#### What are they?

Subnets are smaller networks within your VPC, each with its own IP range and region. They help organize resources and control access.
#### How do they work?

-    Each subnet has a specific IP range (e.g., 10.0.1.0/24) and is tied to a region (e.g., us-central1).
-    Resources in a subnet can communicate with each other directly.

#### Types:

- Public Subnet: Resources can have external IPs and be accessed from the internet.
- Private Subnet: Resources have no external IPs and can only communicate internally or via NAT.

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

Cloud NAT allows VMs in a private subnet to access the internet (e.g., to download updates) without being accessible from the internet.
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

6. VM (Compute Engine)
What is it?

A VM (Virtual Machine) is a computer hosted in the cloud. It can run applications, host websites, or act as a bastion host.
How does it work?

    You choose the operating system, machine type (e.g., CPU and memory), and network settings.
    VMs can have external IPs (public) or be internal-only (private).

How is it managed?

    You manage the VM’s configuration, software, and updates.
    GCP manages the underlying hardware and virtualization.

Steps to Create in Console:

    Go to Compute Engine > VM instances in the GCP Console.

    Click Create Instance.

    1. Public VM:
        Name: public-vm
        Region: us-central1
        Zone: us-central1-a
        Machine type: e2-micro
        Boot disk: Debian (default)
        Firewall: Check "Allow HTTP" and "Allow SSH"
        Networking > Network interfaces:
            Network: ranjitha-tf-vpc
            Subnet: public-subnet
            External IP: Ephemeral (assigns a temporary public IP)
            Network tags: public-vm
        Click Create.

    2. Private VM:
        Name: private-vm
        Region: us-central1
        Zone: us-central1-a
        Machine type: e2-micro
        Boot disk: Debian (default)
        Firewall: No options needed
        Networking > Network interfaces:
            Network: ranjitha-tf-vpc
            Subnet: private-subnet
            External IP: None
        Click Create.

7. Private Service Access
What is it?

Private Service Access allows your VPC to connect to Google services (like Cloud SQL) using private IPs, keeping communication internal and secure.
How does it work?

    You allocate an IP range for Google services.
    GCP creates a private connection between your VPC and Google services using this range.

How is it managed?

    You manage the IP range and connection settings.
    GCP manages the actual connection and routing.

Steps to Create in Console:

    Allocate IP Range:
        Go to VPC network > VPC networks in the GCP Console.
        Click on ranjitha-tf-vpc.
        In the left menu, click Private service connection.
        Click Allocate IP range.
        Fill in:
            Name: private-service-ip
            Region: us-central1
            IP range: 10.10.0.0/16 (must not overlap with VPC subnets)
        Click Allocate.
    Create Private Connection:
        On the same page, click Create connection.
        Select:
            Connected service provider: Google Cloud Platform
            Allocated allocation: private-service-ip
        Click Create connection.

8. Cloud SQL with Private IP
What is it?

Cloud SQL is a managed database service in GCP (e.g., MySQL, PostgreSQL). Using a private IP ensures it’s only accessible within your VPC.
How does it work?

    You create a database instance and assign it a private IP.
    It can only be accessed by resources in your VPC (e.g., private VM).

How is it managed?

    GCP manages the database instance, including backups, updates, and scaling.
    You manage the database schema, users, and access.

Steps to Create in Console:

    Go to SQL > Create Instance in the GCP Console.
    Choose MySQL.
    Fill in:
        Edition Preset: Production
        Database Version: MySQL 8.0
        Instance ID: gcp-mysql-db
        Root Password: StrongP@ssword123!
        Region: us-central1
        Zonal Availability: Multiple zones (Highly Available)
        Machine Type: N2 - 4 vCPU, 32 GB RAM
        Storage Type: SSD
        Storage Capacity: 250 GB
        Enable Automatic Storage Increases: Yes
        Networking:
            IP Assignment: Private IP
            VPC Network: ranjitha-tf-vpc
            Private Services Access: Enabled
            No Public IP: Yes (for security)
            Authorized Networks: Enable (for SQL Proxy or private access)
    Click Create Instance.
    Note the private IP (e.g., 10.0.3.10) assigned to the Cloud SQL instance.

Test Connection:

From the private VM, connect to Cloud SQL:
text
mysql -h 10.0.3.10 -u root -p

Enter the password (StrongP@ssword123!) when prompted.
9. Artifact Registry
What is it?

Artifact Registry is a storage service in GCP for software artifacts like Docker images, Maven packages, or npm packages.
How does it work?

    You create a repository to store artifacts.
    You can push artifacts (e.g., Docker images) to the repository and pull them for deployments.

How is it managed?

    GCP manages the storage and security of the artifacts.
    You manage the artifacts and access permissions.

Steps to Create in Console:

    Go to Artifact Registry > Create Repository in the GCP Console.
    Fill in:
        Name: my-docker-repo
        Format: Docker
        Mode: Standard
        Location Type: Region
        Region: us-central1
        Description: "Docker images for my app"
    Click Create.
    Configure Docker to push/pull images:
    text

gcloud auth configure-docker us-central1-docker.pkg.dev
Push a Docker image:
text

    docker tag my-image:latest us-central1-docker.pkg.dev/my-first-gcp-project/my-docker-repo/my-image:latest
    docker push us-central1-docker.pkg.dev/my-first-gcp-project/my-docker-repo/my-image:latest

10. GKE (Google Kubernetes Engine) Standard Cluster
What is it?

GKE is a managed Kubernetes service in GCP for running containerized applications. A Standard Cluster gives you full control over the nodes (VMs).
How does it work?

    GKE creates a Kubernetes cluster with a control plane (managed by GCP) and worker nodes (VMs you configure).
    You deploy containerized applications (e.g., Docker images) to the cluster.

How is it managed?

    GCP manages the control plane (e.g., Kubernetes API server, scheduler).
    You manage the nodes, including machine types, scaling, and upgrades.

Steps to Create in Console:

    Go to Kubernetes Engine > Clusters in the GCP Console.
    Click Create and choose Standard.
    Fill in:
        Cluster name: drip-nonprod
        Location: Zonal, us-central1-a
        Networking mode: VPC-native
        VPC: ranjitha-tf-vpc
        Subnetwork: private-subnet
        Node pool:
            Machine type: e2-medium
            Nodes: 1 (for nonprod)
    Click Create.
    Authenticate kubectl:
    text

gcloud container clusters get-credentials drip-nonprod --zone us-central1-a --project my-first-gcp-project
Deploy a sample app: Create a deployment.yaml:
text
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
Apply it:
text
kubectl apply -f deployment.yaml
Expose the app:
text

    kubectl expose deployment react-app --type=LoadBalancer --port=80 --target-port=80
    kubectl get service
    Note the external IP to access your app.

11. VPN Gateway
What is it?

A VPN Gateway in GCP (Cloud VPN) is a resource that enables secure communication between your VPC and an external network (e.g., AWS) over the internet.
How does it work?

    It creates a gateway in your VPC that can establish VPN tunnels to a peer gateway (e.g., on AWS).
    It uses IPsec to encrypt traffic between the two networks.

How is it managed?

    You configure the VPN gateway and tunnels in GCP.
    GCP manages the underlying infrastructure and encryption.

Steps to Create in Console:

    Go to Hybrid Connectivity > VPN in the GCP Console.
    Click Create VPN Connection.
    Fill in:
        Name: drip-nonprod-vpn-gateway
        Network: ranjitha-tf-vpc
        Region: us-central1
        IP address: Create a new static IP (e.g., drip-nonprod-vpn-ip)
    Click Create.
    Note the public IP address assigned to the VPN gateway (e.g., 35.200.100.10).

12. Peer VPN Gateway (External Gateway)
What is it?

A Peer VPN Gateway represents the external VPN gateway (e.g., on AWS) that your GCP VPN gateway will connect to.
How does it work?

    It’s a configuration in GCP that specifies the external gateway’s IP address.
    GCP uses this to send VPN traffic to the correct peer.

How is it managed?

    You provide the peer’s IP address and configuration.
    GCP uses this to establish the VPN connection.

Steps to Create in Console:

    In the same VPN setup page, under Peer VPN Gateways, click Add Peer VPN Gateway.
    Fill in:
        Name: drip-nonprod-peer-vpn-gateway
        Interfaces: Add one interface
            IP address: Provide the AWS VPN gateway’s public IP (e.g., 203.0.113.10)
    Click Save.

13. VPN Tunnel
What is it?

A VPN Tunnel is a secure connection between your GCP VPN Gateway and the Peer VPN Gateway, allowing encrypted traffic to flow between the two networks.
How does it work?

    It uses IPsec and a shared key (pre-shared key) to encrypt and authenticate traffic.
    Once established, resources in your VPC can communicate with resources in the external network.

How is it managed?

    You configure the tunnel settings (e.g., shared key, IKE version).
    GCP manages the encryption and tunnel state.

Steps to Create in Console:

    In the VPN setup page, under Tunnels, click Add Tunnel.
    Fill in:
        Name: drip-nonprod-tunnel-1
        VPN Gateway: drip-nonprod-vpn-gateway
        Peer VPN Gateway: drip-nonprod-peer-vpn-gateway
        Shared Secret: Generate a secure key (e.g., 8J2kP9mWqL5xN3vR7tY1uI4oE6gH8jK9lM2nO4pQ6rS8tU0vW2xY4zA6bC8dE0f)
        Remote Peer IP Address: Same as the peer gateway (e.g., 203.0.113.10)
        IKE Version: IKEv2 (recommended)
        Routing Type: Dynamic (BGP)
        Cloud Router: my-router
    Click Create.
    Repeat for additional tunnels if needed (e.g., for redundancy).

14. BGP Session (Dynamic Routing)
What is it?

BGP (Border Gateway Protocol) is a protocol used to dynamically exchange routing information between your VPC and the external network over the VPN tunnel.
How does it work?

    The Cloud Router in your VPC uses BGP to advertise routes (e.g., 10.0.0.0/16) to the external network.
    The external network advertises its routes back to your VPC.
    This allows resources in both networks to communicate seamlessly.

How is it managed?

    You configure BGP settings (e.g., ASNs, peer IPs) in the Cloud Router.
    GCP manages the BGP session and route exchange.

Steps to Create in Console:

    Go to Hybrid Connectivity > Cloud Routers in the GCP Console.
    Click on my-router.
    Under BGP Sessions, click Add BGP Session.
    Fill in:
        Name: drip-nonprod-bgp-1
        Peer ASN: 65001 (AWS ASN)
        Peer IP Address: 169.254.1.2 (BGP IP for the peer, agreed with AWS)
        Advertised Route Priority: 100
        Cloud Router IP Address: 169.254.1.1 (BGP IP for GCP)
    Click Save.
    Configure the AWS side to use the same BGP IPs and ASNs.

Step 3: Test the Setup

    SSH into Public VM:
    text

gcloud compute ssh public-vm --zone=us-central1-a
SSH from Public VM to Private VM:
text
ssh -i ~/.ssh/id_rsa username@10.0.2.10
Connect to Cloud SQL from Private VM:
text
mysql -h 10.0.3.10 -u root -p
Access GKE App: Use the external IP from kubectl get service to access your deployed app.
Verify VPN and BGP:

    Check the VPN tunnel status in Hybrid Connectivity > VPN. It should show "Tunnel Established".
    Check BGP session status in Cloud Routers > my-router. It should show "BGP Established".
    Test connectivity to an AWS resource (e.g., ping an EC2 instance’s private IP from your private VM).
