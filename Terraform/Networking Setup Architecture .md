# Architecture for networking


### Goal:

Set up a secure custom VPC network with:

- Public subnet: VM has external IP, accessible from internet

- Private subnet: VM has no external IP, only communicates internally or via NAT

- Private VM can access internet via NAT (optional)

- Firewall rules for secure access

- Private VM can only be accessed through Public VM

#### Step A: Create VPC Network

- In console > Search VPC networks

- Click "Create VPC network"

    - **Name**: ranjitha-tf-vpc

    - **Subnet creation mode**: Custom

     - **Dynamic routing mode**:Regional 

#### Step B: Create Subnets

1. Public Subnet

   - **Name**: public-subnet

   - **Region**: us-central1

   - **IP range**: 10.0.1.0/24

   - Private Google Access: off(Not needed for public subnet)

2. Private Subnet

    -  **Name**: private-subnet

    -  **Vpc Network**:ranjitha-tf-vpc

     -  **Region**: us-central1

     -  **IP range**: 10.0.2.0/24

    -**Private Google Access** :**ON** (required if accessing Google APIs from private VM)

Click Create.

#### Step C: Create Firewall Rules

1. Allow SSH to Public VM (from internet)

    - **Name**:allow-ssh-public
    - **Network**	:ranjitha-tf-vpc
    - **Priority**	:1000
    -  **Direction of traffic**	:Ingress
    - **Action on match**	:Allow
    - **Targets**	:Specified target tags
    - **Target tags**	:public-vm
    - **Source filter**	:IPv4 ranges
    - **Source IPv4 ranges**	:0.0.0.0/0
    -  **Protocols and ports**	:TCP: 22
    - **Logs**:Off (default)

2. Allow HTTP to Public VM  from Internet

    -**Name**                 : `allow-http-public`   
    - **Network**              : `my-vpc`             
    - **Priority**             : `1000`               
    - **Direction of traffic** : `Ingress`            
    - **Action on match**      : `Allow`              
    - **Targets**              : Specified target tags
    - **Target tags**          : `public-vm`          
    - **Source filter**        : IPv4 ranges          
    - **Source IPv4 ranges**   : `0.0.0.0/0`          
    - **Protocols and ports**  : TCP: `80`            
    - **Logs**                 : Off                  


3. Allow Internal Communication (Public <-> Private VM)

    - **Name**                 : `allow-internal`             
    - **Network**              : `my-vpc`                     
    - **Priority**             : `1000`                       
    - **Direction of traffic** : `Ingress`                    
    - **Action on match**      : `Allow`                      
    - **Targets**              : All instances in the network 
    - **Source filter**        : IPv4 ranges                  
    - **Source IPv4 ranges**   : `10.0.0.0/16`                
    - **Protocols and ports**  : All                          
    - **Logs**                 : Off                          


#### Step D: Setup Cloud Router + NAT (only if private VM needs internet)

- Search for Cloud Router.

- Click "Create Router"

- Name: my-router

- Region: us-central1

-  Network: my-vpc

-  Go to cloud NAT > Create NAT Gateway

 -  Name: my-nat

 -  Region: us-central1

 -  Router: my-router

 -  Subnet: private-subnet

 -  External IP: Auto or static

Step E: Create VM Instances
1. Public VM

    Name: public-vm

    Subnet: public-subnet

    External IP: Ephemeral

    Network tag: public-vm

    Allow SSH & HTTP ✅

2. Private VM

    Name: private-vm

    Subnet: private-subnet

    External IP: None

    Network tag: private-vm

    ✅ Enable "Private Google Access" (comes from subnet)

    Select your service account (optional but good practice)

Step F: Test Connectivity

    SSH into Public VM:

gcloud compute ssh public-vm --zone=us-central1-a

From inside public-vm, connect to private-vm:

ssh <private-vm-internal-ip>
