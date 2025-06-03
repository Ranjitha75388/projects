# GCP 
Google Cloud Platform (GCP) is a powerful suite of cloud computing services provided by Google, enabling individuals and organizations to build, deploy, and manage workloads on Google's robust and scalable infrastructure.

### Key Services

-   **Compute**: Run virtual machines (VMs) for various applications.
-    **Networking**: Create and manage Virtual Private Clouds (VPCs) for secure internal networks.
-    **Storage**: Utilize buckets for scalable and durable object storage.
-    **Databases**: Leverage managed database solutions for structured data.
-    **AI/ML**: Access advanced tools for artificial intelligence and machine learning.

### Prerequisites

### Step 1: Create a Google Account

- A Google account is your entry point to using GCP. It’s the same account you use for Gmail, YouTube, or other Google services.

- Go to https://accounts.google.com and create a Google account if you don't already have one.

#### Steps:
- Open your web browser (e.g., Chrome, Firefox).
- Go to: https://accounts.google.com.
- Click Create account > For myself.
- Fill in your details:
  - First name and last name.
  - Choose a username (e.g., ranji.punitha94@gmail.com).
  - Create a password.
  - Click Next.
- Add a phone number for verification (optional but recommended).
- Follow the prompts to complete the setup.
- Once done, you’ll have a Google account (e.g., ranji.punitha94@gmail.com).

------------------------------------------------------------------------------------------------

### Step 2: Sign Up for Google Cloud Platform (GCP).

- Go to: https://console.cloud.google.com/.
- Sign in with your Google account (ranji.punitha94@gmail.com).
- You’ll see a welcome page. Click Get Started for Free.
- Accept the terms of service by checking the box and clicking Agree and Continue.
- Set up a billing account:
  - Enter your country and billing information (e.g., credit/debit card details).
  - GCP offers a $300 free credit for 90 days to new users, so you can try things out without immediate cost.
  - Click Start My Free Trial.
  - Once billing is set up, you’ll be taken to the GCP Console (a dashboard where you manage your resources).

---------------------------------------------------------------------------------------------------------------------- 
### Step 3: Create a New Project in GCP.

- A project in GCP is like a container for all our resources (e.g., VMs, networks). Each project has a unique ID and keeps our resources organized.

#### Steps:

- In the GCP Console, look at the top bar. You’ll see a project drop-down (it might say “Select a project” or show a default project).
- Click the drop-down and then click New Project (top-right corner).
- Fill in the details:
  - Project Name: my-first-gcp-project.
  - Leave Location as “No organization” (default for personal accounts).
  - Click Create.
- Wait a few seconds for the project to be created.
- Once created, click the project drop-down again and select "my-first-gcp-project" to switch to it.
-------------------------------------------------------------------------------------------------------------------------------------------------------

##  Manual Setup resourses in console

### 1. VPC (Virtual Private Cloud)
   
#### What is it?

- A VPC is like a private, isolated network in GCP where you can launch resources like VMs, databases, and GKE clusters.
-  You define an IP range for the VPC (e.g., 10.0.0.0/16), and all resources inside it can communicate securely.
-  You can create subnets within the VPC for better organization and security.
-  It isolates your resources from other GCP projects and the public internet unless explicitly allowed.

### Architecture diagram

![image](https://github.com/user-attachments/assets/8d540a82-0b70-445b-b258-0b412b26bb1c)


### Steps to Create in Console:

- In the GCP Console, go to the left menu.
- Click **VPC network** > VPC networks.
- Click Create VPC Network (top of the page).
- Fill in:
  - **Name**: ranjitha-tf-vpc.
  - **Subnet creation mode**: Custom (we’ll define our own subnets).
  - **Dynamic routing mode**: Regional.
-  Click Create.
------------------------------------------------------------------------------------------------------------------------------------------------

### 2. Subnets in VPC
#### What are they?
- Subnets are smaller networks within your VPC. They help organize resources and control access by dividing the VPC into sections.
- Resources in a subnet can communicate with each other directly.

#### Types:

- **Public Subnet**: Resources can have external IPs and be accessed from the internet.
- **Private Subnet**: Resources have no external IPs and can only communicate internally or via NAT.

### Steps to Create in Console:

1.After creating the VPC, you’ll be prompted to add subnets (or go to the VPC details and click Add Subnet).

2.Public Subnet:
   - **Name**: public-subnet
   - **Region**: us-central1
   - **IP range**: 10.0.1.0/24
   - **Private Google Access**: Off (not needed for public subnet)

3.Private Subnet:
   - **Name**: private-subnet
   - **Region**: us-central1
   - **IP range**: 10.0.2.0/24       
   - **Private Google Access**: On (required for accessing Google APIs from private VMs)

4.Database Subnet:
   - **Name**: db-subnet
   - **Region**: us-central1
   - **IP range**: 10.0.3.0/24
   - **Private Google Access**: On

5.Click Create.

---------------------------------------------------------------------------------------------------------------------
### 3. Firewall Rules

#### What are they?

- Firewall rules control what traffic is allowed into or out your VPC. They act like security guards for your network.

#### How do they work?
- Rules are applied based on IPs, ports, protocols, and tags.
- By default, GCP blocks all ingress (incoming) traffic and allows all egress (outgoing) traffic.
- You create rules to allow specific traffic, like SSH (port 22) or HTTP (port 80).

### Architeture diagram

![image](https://github.com/user-attachments/assets/08758406-93e2-4747-9138-89ccac2297bc)


### Steps to Create in Console:
1.In the GCP Console, go to VPC network > Firewall.

2.Click Create Firewall Rule.

3.Allow SSH to Public VM (from internet):
  - **Name**: allow-ssh-public
  - **Network**: ranjitha-tf-vpc
  - **Priority**: 1000
  - **Direction of traffic**: Ingress(incoming traffic).
  - **Action on match**: Allow
  - **Targets**: Specified target tags
  - **Target tags**: public-vm
  - **Source filter**: IPv4 ranges
  - **Source IPv4 ranges**: 0.0.0.0/0 (allows traffic from anywhere).
  - **Protocols and ports**: TCP: 22(SSH port)
  - **Logs**: Off
  - Click Create.

4.Allow HTTP to Public VM (from internet):
  - **Name**: allow-http-public
  - **Network**: ranjitha-tf-vpc
  - **Priority**: 1001
  - **Direction of traffic**: Ingress
  - **Action on match**: Allow
  - **Targets**: Specified target tags
  -  **Target tags**: public-vm
  -  **Source filter**: IPv4 ranges
  -  **Source IPv4 ranges**: 0.0.0.0/0
  -  **Protocols and ports**: TCP: 80(HTTP port)
  -  **Logs**: Off
  - Click Create.

5.Allow Internal Communication (between resources in the VPC):
  - **Name**: allow-internal
  - **Network**: ranjitha-tf-vpc
  - **Priority**: 1002
  - **Direction of traffic**: Ingress
  - **Action on match**: Allow
  - **Targets**: All instances in the network
  - **Source filter**: IPv4 ranges
  - **Source IPv4 ranges**: 10.0.0.0/16 (the VPC’s IP range).
  - **Protocols and ports**: All
  - **Logs**: Off
  - Click Create.

6.Allow Private VM to Cloud SQL (MySQL):(**Optional** refer:3 Targets: All instances in the network.so not necessary.)
 - **Name** : allow-mysql-access
 - **Network** : ranjitha-tf-vpc
 - **Direction** :Ingress
 - **Action** :Allow
 - **Source IP ranges** :10.0.0.0/24 (your private VM subnet)
 - **Target IP ranges** :10.127.0.4/32 (your Cloud SQL IP)
 - **Protocols and Ports** :tcp:3306
----------------------------------------------------------------------------------------------------------------------------------------------

### 4. Cloud Router
#### What is it?

- A Cloud Router is a service in GCP that helps manage network routes dynamically, especially for hybrid connectivity (e.g., connecting GCP to AWS).
#### How does it work?

- It uses BGP (Border Gateway Protocol) to advertise routes between networks.
- It’s required for Cloud NAT to allow private VMs to access the internet.

### Architeture diagram

![image](https://github.com/user-attachments/assets/58572ae8-03f5-4ef7-a15d-c116d8dc87eb)

### Steps to Create in Console:

1.Go to Hybrid Connectivity > Cloud Routers.

2.Click Create Router.

3.Fill in:
  - **Name**: my-router
  - **Region**: us-central1
  - **Network**: ranjitha-tf-vpc
  - **Google ASN**: 64514 (a unique number for BGP routing; note this for the AWS setup later).

4.Click Create.

-----------------------------------------------------------------------------------------------------------------------------------
### 5. Cloud NAT (Network Address Translation)

#### What is it?

- Cloud NAT allows VMs in a private subnet to access the internet (e.g., to download updates) without exposing them to incoming internet traffic.
#### How does it work?

- It translates the private IP of your VM to a public IP for outbound traffic.
- Inbound traffic from the internet is blocked, keeping the VM secure.

### Architeture diagram

![image](https://github.com/user-attachments/assets/951b36d6-239f-475d-9e1f-32680c3b0064)

### Steps to Create in Console:

1.In the GCP Console, go to VPC network > Cloud NAT.

2.Click Create NAT Gateway.

3.Fill in:
  - **Name**: my-nat
  - **Region**: us-central1
  - **Router**: my-router.(the router created above).
  - **Subnet**: Select Specific subnets and choose private-subnet
  - **External IP**: Select Auto (GCP will assign a public IP for NAT).
4.Click Create.
--------------------------------------------------------------------------------------------------------------------------------------
### 6. VM (Compute Engine)
#### What is it?

- A VM (Virtual Machine) is a computer hosted in the cloud. It can run applications, host websites, or act as a bastion host.
#### How does it work?

- You choose the operating system, machine type (e.g., CPU and memory), and network settings.
- VMs can have external IPs (public-vm) or be internal-only (private-vm).

## Architeture diagram

![image](https://github.com/user-attachments/assets/122a1ead-2efc-48e0-aeef-8ed412a5b389)


### Steps to Create in Console:

1.In the GCP Console, go to Compute Engine > VM instances.

2.Click Create Instance.

3.Public VM:
 - **Name**: public-vm
 - **Region**: us-central1
 - **Zone**: us-central1-a
 - **Machine type**: Select e2-micro (a small, free-tier-eligible machine).
 - **Boot disk**: Debian (default)
 - **Firewall**: Check Allow HTTP traffic and Allow SSH traffic.
 - **Networking** > Network interfaces:
    - **Network**: ranjitha-tf-vpc
    - **Subnet**: public-subnet
    - **External IP**: **Ephemeral** (assigns a temporary public IP)
    - **Network tags**: Enter public-vm (matches the firewall rule).
 - Click Create.

4.Private VM:
 - **Name**: private-vm
 - **Region**: us-central1
 - **Zone**: us-central1-a
 - **Machine type**: e2-micro
 - **Boot disk**: Debian (default)
 - **Firewall**: Leave unchecked (no internet access needed).
 - **Networking** > Network interfaces:
   - **Network**: ranjitha-tf-vpc
   - **Subnet**: private-subnet
   - **External IP**: Select **None** (no public IP).
  - Click Create.
-----------------------------------------------------------------------------------------------------------------------------------------------------

### 7. Private Service Access
#### What is it?

- Private Service Access allows your VPC to connect to Google services (like Cloud SQL) using private IPs, keeping communication internal and secure.
#### How does it work?

- You allocate an IP range for Google services.
- This ensures that your resources (like Cloud SQL) can communicate with your VPC privately, without going over the public internet.

### Architeture diagram

![image](https://github.com/user-attachments/assets/9e56384f-1aee-45ad-a12b-b5d68c6c40d7)

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
 - On the same page, click **Create connection**.
 - Select:
   - Connected service provider: Google Cloud Platform
   - Allocated allocation: private-service-ip
 - Click Create connection.
---------------------------------------------------------------------------------------------------------------------------

### 8. Cloud SQL with Private IP
#### What is it?

- Cloud SQL is a managed database service in GCP (e.g., MySQL, PostgreSQL). Using a private IP ensures it’s only accessible within your VPC.
#### How does it work?

- You create a database instance and assign it a private IP.
- It can only be accessed by resources in your VPC (e.g., private VM).

### Architeture diagram

![image](https://github.com/user-attachments/assets/07509304-2a30-43cf-936e-ed2da83b0d9d)

### Steps to Create in Console:

1. Go to SQL > Create Instance in the GCP Console.
2. Choose MySQL.
3. Fill in:
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
  
  - Networking:
  
    - **IP Assignmen**t: Private IP
    - **VPC Network**: ranjitha-tf-vpc
    - **Private Services Access**:Ensure it's Enabled(from the previous step).
    - **No Public IP**: Yes (for security)
    - **Authorized Networks**: Leave as is (we’ll connect via private IP).

4. Click Create Instance.

5.Once created, note the private IP (e.g., 10.0.3.10) assigned to the Cloud SQL instance (visible in the instance details).

#### Test Connection:

1.SSH into your private-vm 
2.Install the MySQL client on private-vm:
```
sudo apt update
sudo apt install mysql-client -y
```
3.Connect to Cloud SQL:
```
mysql -h 10.0.3.10 -u root -p
```
4.Enter the password when prompted.

------------------------------------------------------------------------------------------------------------------------------------

### 9. Artifact Registry
#### What is it?

- Artifact Registry is a storage service in GCP for software artifacts like Docker images, Maven packages, or npm packages.
#### How does it work?

- You create a repository to store artifacts.
- You can push artifacts (e.g., Docker images) to the repository and pull them for deployments.

### Architeture diagram

![image](https://github.com/user-attachments/assets/d3974b1c-3e0e-4287-bc47-0e9d6401ca98)


### Steps to Create in Console:

1.Go to Artifact Registry > Create Repository in the GCP Console.

2.Fill in:
  - **Name**: my-docker-repo
  - **Format**: Docker
  - **Mode**: Standard
  - **Location Type**: Region
  - **Region**: us-central1
  - **Description**: "Docker images for my app"

3.Click Create.

### Push a Docker Image:

- If you have Docker installed on your local machine:
- #### Configure Docker to authenticate with Artifact Registry:
```    
 gcloud auth configure-docker us-central1-docker.pkg.dev
```
- #### Tag and Push a Docker image:
```
 docker tag my-image:latest us-central1-docker.pkg.dev/my-first-gcp-project/my-docker-repo/my-image:latest
 docker push us-central1-docker.pkg.dev/my-first-gcp-project/my-docker-repo/my-image:latest
```
-------------------------------------------------------------------------------------------------------------------------------

### 10. GKE (Google Kubernetes Engine) Standard Cluster

#### What is it?
- GKE is a managed Kubernetes service in GCP for running containerized applications.
- A **Standard Cluster** gives you full control over the nodes (VMs).
- A **autopilot cluster** managed by google.

#### How does it work?

- GKE creates a Kubernetes cluster with a control plane (managed by GCP) and worker nodes (VMs you configure).
- You deploy containerized applications (e.g., Docker images) to the cluster.

### Architeture diagram

![image](https://github.com/user-attachments/assets/9c41ecda-ff5d-4335-b771-41fb7dc95113)

### Steps to Create in Console:

1.Go to Kubernetes Engine > Clusters in the GCP Console.

2.Click Create and choose Standard.

3.Fill in:
  - **Cluster name**: drip-nonprod
  - **Location**: Zonal, us-central1-a
  - **Networking mode**: VPC-native
  - **VPC**: ranjitha-tf-vpc
  - **Subnetwork**: private-subnet
  - **Node pool**:
    - **Machine type**: e2-medium
    - **Nodes**: 1 (for nonprod)
4.Click Create.

### Deploy a Sample App:

#### 1.Authenticate kubectl:
```
 gcloud container clusters get-credentials drip-nonprod --zone us-central1-a --project my-first-gcp-project
```
#### 2.Create a deployment.yaml:
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
3.Apply the Deployment:
```
kubectl apply -f deployment.yaml
```
4.Expose the app:
```
 kubectl expose deployment react-app --type=LoadBalancer --port=80 --target-port=80
```
5.Get the External IP:
```
kubectl get service
```
- Look for the react-app service and note its EXTERNAL-IP. Open this IP in a browser to see the app.
---------------------------------------------------------------------------------------------------------------------------------------------------

### 11. Connect GCP to AWS Using a VPN Gateway

### 11.1.Create VPN Gateway in GCP.
#### What is it?

- A Cloud VPN Gateway in GCP is a resource that enables secure communication between your GCP VPC and AWS VPC using an IPsec VPN over the internet.

### Architeture diagram

![image](https://github.com/user-attachments/assets/655ab5a3-8939-4aa6-8205-48c1f9c4216b)

### Steps to create in console
### 1.Navigate to External IP Addresses:
 Each of the four interfaces of the HA VPN gateway needs a unique external IP to communicate with the AWS VPN gateway.

- In the left-hand menu, go to VPC Network > IP Addresses.
- Reserve Four External IPs:
- Click Reserve External Address:
  - **Name**: gcp-vpn-ip-0.
  - **Network Service Tier**: Premium.
  - **IP Version**: IPv4.
  - **Region**: us-central1.
  - **Type**: Regional.
  - Click Reserve.
  - Note the IP (e.g., 35.200.100.10).
- Repeat for the remaining IPs:
  - **Name**: gcp-vpn-ip-1, IP: 35.200.100.11.
  
### 2.Create the HA VPN Gateway with Four Interfaces

- Go to Hybrid Connectivity > VPN.
- Click Create VPN Connection at the top.
- Choose High-availability (HA) VPN.
- Click Continue.
- Configure the HA VPN Gateway:
  - **VPN Gateway Name**: Enter gcp-to-aws-ha-vpn-gateway.
  - **Network**: Select your VPC ranjitha-tf-vpc.
  - **Region**: Select us-central1.
  - **Stack Type**: Leave as IPv4 (single-stack) (unless AWS requires IPv6).
  - **IP Addresses**: Since we already reserved IPs, select Use existing IP addresses:
       - **Interface 0**: Select gcp-vpn-ip-0 (e.g., 35.200.100.10).
       - **Interface 1**: Select gcp-vpn-ip-1 (e.g., 35.200.100.11).
- Click Create and Continue.
- After a few seconds, the gateway will be created, and you’ll see the two interfaces with their IPs (35.200.100.10 and 35.200.100.11).

### 3.Create a Cloud Router

- After creating the HA VPN gateway, the wizard prompts you to create or select a Cloud Router.
- Choose Create a new Cloud Router.
- Configure the Cloud Router:
   - **Name**: Enter gcp-to-aws-router.
   - **Region**: Pre-filled as us-central1. Leave it as is.
   - **Google ASN**: Enter 65001 (a private ASN).      # This must not conflict with AWS (we’ll use 64512 for AWS).
   - Leave other settings at their defaults.
- Click Create and Continue.

### 4.Create a Peer VPN Gateway for AWS

- In the VPN setup wizard, scroll to Peer VPN Gateway.
- Select On-prem or Non Google Cloud.
- Click Create New Peer VPN Gateway.
- Configure the Peer VPN Gateway:
   - Peer VPN Gateway Name: Enter aws-peer-vpn-gateway.
   - Interfaces: Select two interfaces.
       - **Interface 0 IP Address**: Enter a placeholder (e.g., 1.1.1.1).
       - **Interface 1 IP Address**: Enter 1.1.1.2.
- Click Create.
- Back in the wizard, ensure aws-peer-vpn-gateway is selected.
- The peer VPN gateway represents the AWS side. We’ll update the placeholder IPs with the actual AWS external IPs after downloading the configuration file.

### 5.Create two VPN Tunnels
- In the VPN setup wizard, scroll to VPN Tunnels.
- Ensure Create a pair of VPN tunnels is selected.
- Tunnel 1 (Interface 0):
    - **Name**: gcp-to-aws-tunnel-0.
    - **Associated Cloud VPN Gateway Interface**: Interface 0 (35.200.100.10).
    - **Associated Peer VPN Gateway Interface**: Interface 0 (1.1.1.1, placeholder).
    - **IKE Version**: IKEv2 (required for HA VPN).
    - **IKE Pre-shared Key**: Leave blank for now (we’ll update it with the AWS key later).
- Tunnel 2 (Interface 1):
   - **Name**: gcp-to-aws-tunnel-1.
   - **Associated Cloud VPN Gateway Interface**: Interface 1 (35.200.100.11).
   - **Associated Peer VPN Gateway Interface**: Interface 1 (1.1.1.2).
   - **IKE Version**: IKEv2.
   - **IKE Pre-shared Key**: Leave blank.
- Click Create and Continue.

### 6.Configure BGP Sessions
- BGP Session for Tunnel 0:
   - **Name**: bgp-session-0.
   - **Peer ASN**: Enter 64512 (AWS ASN, to be confirmed later).
   - **Cloud Router BGP IP**: Enter 169.254.1.1 (placeholder).
   - **BGP Peer IP**: Enter 169.254.1.2 (placeholder).
   - **Advertised Route Priority** (MED): 100.
   - Click Save BGP Configuration.
- BGP Session for Tunnel 1:
   - **Name**: bgp-session-1.
   - **Peer ASN**: 64512.
   - **Cloud Router BGP IP**: 169.254.2.1.
   - **BGP Peer IP**: 169.254.2.2.
   - **Advertised Route Priority** (MED): 100.
   - Click Save BGP Configuration.
- Click OK to finish the initial setup.

## 7.Configure the AWS Side

### 7.1.Create Customer Gateways:
- Go to VPC > Customer Gateways.
- Create two Customer Gateways (one for each GCP interface):
   - **Name**: gcp-customer-gateway-0.
   - **BGP ASN**: 65001 (GCP ASN).
   - **IP Address**: 35.200.100.10.
- Click Create Customer Gateway.
    - **Name**: gcp-customer-gateway-1.
    - **BGP ASN**: 65001.
    - **IP Address**: 35.200.100.11.
- Click Create Customer Gateway.
            
### 7.2.Create a Virtual Private Gateway:
- Go to VPC > Virtual Private Gateways.
- Click Create Virtual Private Gateway:
   - **Name**: aws-to-gcp-vpg.
   - **ASN**: Custom ASN, enter 64512.
   - Click Create Virtual Private Gateway.
- Select the gateway, click Actions > Attach to VPC, and choose your AWS VPC (172.16.0.0/16).
- Enable Route Propagation:
   - Go to VPC > Route Tables.
   - Select the route table associated with your VPC (e.g., the default route table).
   - Click the Route Propagation tab.
   - Click Edit Route Propagation.
   - Check the box next to aws-to-gcp-vpg to enable propagation.
   - Click Save.

### 7.3.Create Site-to-Site VPN Connections:
- Go to VPC > Site-to-Site VPN Connections.
- Create two VPN connections:
    - **Name**: aws-to-gcp-vpn-0.
    - **Target Gateway Type**: Virtual Private Gateway.
    - **Virtual Private Gateway**: aws-to-gcp-vpg.
    - **Customer Gateway**: gcp-customer-gateway-0.
    - **Routing Options**: Dynamic (requires BGP).
    - Click Create VPN Connection.
 - Repeat for the other: aws-to-gcp-vpn-1 with gcp-customer-gateway-1.
  
 ### 7.4.Download Configuration Files:
 - Select aws-to-gcp-vpn-0, click Download Configuration, choose Generic, and download.
 - Open the file and note:
    - **Outside IP**: AWS external IP (e.g., 52.10.20.30).
    - **Inside IPs**: BGP IPs (e.g., GCP: 169.254.1.1, AWS: 169.254.1.2).
    - **Pre-shared Key**: E.g., abc123xyz.
 - Repeat for aws-to-gcp-vpn-1 (e.g., outside IP: 52.10.20.31, inside IPs: 169.254.2.1/169.254.2.2, key: def456uvw).
        
### 8.Update GCP Peer VPN Gateway with AWS Outside IPs

- In the GCP Console, go to Hybrid Connectivity > VPN.
- Edit the Peer VPN Gateway:
- Click gcp-to-aws-ha-vpn-gateway.
- Scroll to Peer VPN Gateway and click aws-peer-vpn-gateway.
- Click Edit.
- Update the IPs with the AWS outside IPs from the configuration files:
    - Interface 0 IP Address: 52.10.20.30.
    - Interface 1 IP Address: 52.10.20.31.
 - Click Save.

### 9.Update VPN Tunnels with AWS Pre-shared Keys
- In Hybrid Connectivity > VPN, click gcp-to-aws-ha-vpn-gateway.
- Under VPN Tunnels, click gcp-to-aws-tunnel-0.
- Click Edit.
- IKE Pre-shared Key: Enter the key from aws-to-gcp-vpn-0 (e.g., abc123xyz).
- Click Save.
-  Repeat for the others:gcp-to-aws-tunnel-1: Use key def456uvw.
            
### 10.Update BGP Sessions with AWS Inside IPs
- In the GCP Console, go to Hybrid Connectivity > Cloud Routers.
- Click gcp-to-aws-router.
- Edit BGP Sessions:
- Under BGP Sessions, click bgp-session-0:
   - Cloud Router BGP IP: Update to the GCP inside IP (e.g., 169.254.1.1).
   - BGP Peer IP: Update to the AWS inside IP (e.g., 169.254.1.2).
   - Click Save.
- Repeat for the others:bgp-session-1: GCP: 169.254.2.1, AWS: 169.254.2.2.

### 11.Create Firewall Rules in GCP
- In the GCP Console, go to VPC Network > Firewall Rules.
- Allow AWS Traffic:
   - **Name**: allow-aws-to-gcp.
   - **Network**: ranjitha-tf-vpc.
   - **Direction of traffic**: Ingress.
   - **Action on match**: Allow.
   - **Source filter**: IPv4 ranges.
   - **Source IPv4 ranges**: 172.16.0.0/16.
   - **Protocols and ports**: All.
   - Click Create.
 - Allow BGP Traffic:
   - **Name**: allow-bgp.
   - **Network**: ranjitha-tf-vpc.
   - **Direction of traffic**: Ingress.
   - **Action on match**: Allow.
   - **Source filter**: IPv4 ranges.
   - **Source IPv4 ranges**: 169.254.0.0/16.
   - **Protocols and ports**: TCP port 179.
   - Click Create.

### 12.Check Status in GCP and AWS
- Check GCP Tunnel Status:
   - Click gcp-to-aws-ha-vpn-gateway.
   - Verify all tunnels (gcp-to-aws-tunnel-0 to gcp-to-aws-tunnel-3) show Established.
- Check GCP BGP Status:
   - Click gcp-to-aws-router.
   - Under BGP Sessions, ensure bgp-session-0 to bgp-session-3 are Established.
- Check AWS VPN Status:
   - In the AWS Console, go to VPC > Site-to-Site VPN Connections.
   - Select each VPN connection (aws-to-gcp-vpn-0 to aws-to-gcp-vpn-3).
   - Check the Status column; all should show Up.

### 13.Test the Connection
#### Test from GCP to AWS
- SSH into the GCP public VM:
- Ping the AWS EC2 Instance:
 ```
  ping 172.16.1.10
```
- If successful, you’ll see responses (e.g., 64 bytes from 172.16.1.10).

#### Test from AWS to GCP:

- SSH into the Ec2 instance.
- Ping the GCP public-vm internal IP (e.g., 10.0.1.2)
```
 ping 10.0.1.2
```
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
## GCP Resource Setup with Terraform

Terraform is a popular Infrastructure as Code (IaC) tool used to provision and manage Google Cloud infrastructure. It allows you to define your desired infrastructure state in **code**, and then Terraform will **automate the process of creating and updating those resources on Google Cloud**. You can use the [Terraform Registry](https://registry.terraform.io/providers/hashicorp/google/latest/docs) provider to interact with Google Cloud resources. 

### Prerequisites
#### Step 1: Create a Google Account.
#### Step 2: Sign Up for Google Cloud platform.
#### Step 3: Install gcloud CLI in terminal (Google Cloud SDK)

 - The gcloud CLI is a command-line tool that lets you interact with GCP resources from your computer.

#### Steps (for Linux)
- Open a terminal on your computer.
- Download the Google Cloud SDK:
```
 curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-451.0.1-linux-x86_64.tar.gz
```
- Extract the downloaded file:
```
 tar -xvzf google-cloud-sdk-*.tar.gz
```
- Install the SDK:
```
 ./google-cloud-sdk/install.sh
```
- Initialize the gcloud CLI:
```
gcloud init
```
- Follow the prompts:
   - Sign in with Google account (ranji.punitha94@gmail.com) by opening the provided URL in a browser and entering the verification code.
   - Select your project (create above in manuall setup step-5)

- Verify the installation:
```
gcloud --version
```
### Step 4: Create and Use a Service Account in GCP Console

- Create a Service Account:

  - Go to IAM & Admin > Service Accounts in the GCP Console.
  - Click Create Service Account.
     - Name: vm-service-account.
     - Grant Role: Compute Admin ,sevice networking admin(or least privilege needed, e.g., Editor).
     - Click Done.
- Create and Download a JSON Key:
   - Go to the service account (vm-service-account).
   - Click Keys > Add Key > Create New Key.
   - Select JSON format and download the file (e.g., vm-service-account.json).
- Set Environment Variable:
   - Store the JSON file securely on your local machine in your working directory where all terraform files to be run.
   - Set the environment variable for Terraform to use the credentials:
   ```
    export GOOGLE_APPLICATION_CREDENTIALS="/path/to/your/vm-service-account.json"
    ```
- To Check Which Credentials is Using
```
  gcloud auth list
```
### Step 5: Install Terraform

- To Download and install Terraform On Linux
```
 curl -fsSL https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip -o terraform.zip
 unzip terraform.zip
 sudo mv terraform /usr/local/bin/
 ```
- Verify Installation:
```
 terraform --version
```
## Step-by-Step Guide to Apply the Terraform Configuration

### Step 1: Set Up Your Working Directory

1.Create a Directory:
```
mkdir gcp-terraform-project
cd gcp-terraform-project
```
2.Ensure the Service Account JSON File is Present:
 - Place the "vm-service-account.json" file in the same directory "gcp-terraform-project"

3.Create the Terraform File in "gcp-terraform-project" directory.
    
- **provider.tf** :It ensures Terraform knows which cloud platform to work with and how to connect to it securely.
  [Link](https://github.com/jumisa/terraform-gcp/blob/feature/gcp-r/GCP-resourses-tf/provider.tf)
- **variables.tf** : Declares reusable variables (e.g., project ID, region, VPC name).
  [Link](https://github.com/jumisa/terraform-gcp/blob/feature/gcp-r/GCP-resourses-tf/variables.tf)
- **main.tf**: It allows you to create, update, or delete resources consistently and repeatedly with a single command.
  [Link](https://github.com/jumisa/terraform-gcp/blob/feature/gcp-r/GCP-resourses-tf/main.tf)
- **outputs.tf**: Displays important values after creation (e.g., VM IPs, GKE LoadBalancer IP).
  [Link](https://github.com/jumisa/terraform-gcp/blob/feature/gcp-r/GCP-resourses-tf/outputs.tf)
- **terraform.tf**: Configures Terraform settings like version and state storage.
  [Link](https://github.com/jumisa/terraform-gcp/blob/feature/gcp-r/GCP-resourses-tf/terraform.tf)
- **terraform.tfvars**: Sets specific values for variables (e.g., region = "us-central1").
  [Link](https://github.com/jumisa/terraform-gcp/blob/feature/gcp-r/GCP-resourses-tf/terraform.tfvars)

### Step 2: Initialize Terraform
- Run terraform init:
```
 terraform init
```
#### Explanation:
- terraform init initializes the Terraform working directory.
- It downloads the necessary provider plugins (e.g., google provider for GCP).
- It sets up the backend for storing Terraform state (by default, it uses a local file terraform.tfstate).

### Step 3: Create an Execution Plan
- Run terraform plan:
```
 terraform plan 
```
#### Explanation:
- terraform plan creates an execution plan describing what Terraform will do to achieve the desired state (defined in all tf files. ex:main.tf).
- It compares the current state (stored in terraform.tfstate) with the desired state and shows the changes (e.g., resources to be created).

### Step 4: Apply the Changes
- Run terraform apply:
```
 terraform apply
```
#### Explanation:
- terraform apply executes the plan to create, update, or delete resources in GCP.
- Using the tfplan file ensures that only the changes shown in the plan are applied.

### Cleanup (Optional)
- To avoid incurring charges, you can destroy the resources:
```
terraform destroy
```
#### Explanation:
- terraform destroy removes all resources created by the Terraform configuration.


------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
## Modularization in GCP (Terraform) 

[Modules documentation](https://developer.hashicorp.com/terraform/language/modules)

### What is Terraform Modularization?

Terraform is a tool that helps you create and manage cloud resources (like networks, servers, or Kubernetes clusters) using code. When you put all your code in one file (like your main.tf), it can get long and hard to manage. Modularization means splitting that big file into smaller, reusable pieces called modules. Each module handles a specific part of your infrastructure, like the network, Kubernetes clusters, or virtual machines.

### Why Modularize?

- **Easier to Understand**: Smaller files are simpler to read and work with.
- **Reusable**: You can use the same module in different projects (e.g., a VPC module for multiple environments).
- **Teamwork**: Different team members can work on different modules without conflicts.
- **Maintainable**: If something changes (like a firewall rule), you update only one module, not the whole file.

### Modularized Structure
```
.
├── main.tf
├── outputs.tf
├── provider.tf
├── terraform.tf
├── terraform.tfvars
├── variables.tf
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── subnets/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── private_service_access/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── firewall/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── vpn/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── cloud_router/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── gke/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── vms/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── artifact_registry/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
```
### Steps to Create the Modularized Terraform Structure
### Step 1: Create a New Directory for the Modularized Setup

#### 1.Create and move to the new directory:
```
mkdir ~/modular-terraform-project
cd ~/modular-terraform-project
```
#### Step 2: Create the Root Module Files

The root module is the main part of your Terraform configuration that calls the modules. It includes files like main.tf, outputs.tf, provider.tf, terraform.tf, terraform.tfvars, and variables.tf. We’ll create these files in the new directory.
 #### - Create the root module files
```
touch main.tf outputs.tf provider.tf terraform.tf terraform.tfvars variables.tf
```
**Important**: Ensure the credential.json file exists at the new current directory (~/modular-terraform-project)

1.provider.tf

2.terraform.tf

3.variables.tf

4.terraform.tfvars

5.main.tf

6.outputs.tf


#### Step 3: Create the Modules Directory and Module Subdirectories
#### 1.Create the modules directory in the  new directory (~/modular-terraform-project).
```
mkdir modules
```
#### 2.Create subdirectories for each module
```
mkdir -p modules/{vpc,subnets,private_service_access,firewall,vpn,cloud_router,gke,vms,artifact_registry}
```
#### 3.Create files in each module.
```
touch modules/vpc/{main.tf,variables.tf,outputs.tf}
touch modules/subnets/{main.tf,variables.tf,outputs.tf}
touch modules/private_service_access/{main.tf,variables.tf,outputs.tf}
touch modules/firewall/{main.tf,variables.tf,outputs.tf}
touch modules/vpn/{main.tf,variables.tf,outputs.tf}
touch modules/cloud_router/{main.tf,variables.tf,outputs.tf}
touch modules/gke/{main.tf,variables.tf,outputs.tf}
touch modules/vms/{main.tf,variables.tf,outputs.tf}
touch modules/artifact_registry/{main.tf,variables.tf,outputs.tf}
```
#### Step 4: Add Content to Module Files

Each module will contain:

- **main.tf**: The resource definitions.
- **variables.tf**: Input variables the module needs.
- **outputs.tf**: Values the module returns to the root module or other modules.

1.VPC Module
2.Subnets Module
3.Private Service Access Module
4.Firewall Module
5.VPN Module
6.Cloud Router and Nat Module
7.GKE Module
8.VMs Module
9.Artifact Registry Module

#### Step 5:Test the Modularized Configuration

1.Initialize Terraform:
- This downloads the Google provider and sets up the modules.
```
terraform init
```
2.Validate the Configuration:
- Check for syntax errors:
```
terraform validate
```
3.Plan the Changes:
- Generate a plan to see what Terraform will create:
```
terraform plan
```
4.Apply the Configuration:
- Create the resources:
```
terraform apply
```
### How the Modular Structure Works

- **Root Module**: The files in the root directory (main.tf, etc.) act as the “main program” that calls the modules.
- **Modules**: Each module (e.g., vpc, gke) is like a function that handles one part of your infrastructure (e.g., creating a VPC or GKE cluster).
- **Inputs and Outputs**: Modules take inputs (via variables.tf) and return outputs (via outputs.tf). For example, the VPC module outputs vpc_id, which the Subnets module uses.
- **Dependencies**: Terraform automatically figures out the order to create resources based on dependencies (e.g., create the VPC before subnets).
- **Reusability**: You can reuse these modules in other projects by copying the modules directory and adjusting terraform.tfvars.###

























