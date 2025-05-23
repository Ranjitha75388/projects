# Architecture for networking

                +------------------+
                |    Internet      |
                +--------+---------+
                         |
              [ External IP: public-vm ]
                         |
                +--------v---------+
                |   Public Subnet   |
                |   10.0.1.0/24     |
                +--------+---------+
                         |
                +--------v---------+        +----------------+
                |   my-vpc Network | <----> |  Cloud Router  |
                +--------+---------+        +--------+-------+
                         |                           |
                +--------v---------+        +--------v--------+
                |  Private Subnet  |        |    Cloud NAT     |
                |   10.0.2.0/24    |        +------------------+
                +--------+---------+
                         |
           [ Internal IP only (private-vm) ]


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

   - **Private Google Access**: off(Not needed for public subnet)

2. Private Subnet

    -  **Name**: private-subnet

    -  **Vpc Network**:ranjitha-tf-vpc

     -  **Region**: us-central1

     -  **IP range**: 10.0.2.0/24

    - **Private Google Access** :**ON** (required if accessing Google APIs from private VM)

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

    - **Name**                 : `allow-http-public`   
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

 -  External IP: Auto

####  Step E: Create VM Instances

#### 1.Public vm

- Go to: Compute Engine > VM instances

- Click "Create Instance"

- Name: public-vm

- Region: us-central1, Zone: us-central1-a

- Machine type: e2-micro

- Boot disk: Default (Debian)

- Firewall: Check "Allow HTTP" and "Allow SSH"

- Networking > Network interfaces

    - Network: ranjitha-tf-vpc
    
    - Subnet: public-subnet

    - External IP: **Ephemeral**

    - Network tags: public-vm

Click Create

- Security: Select the service account (optional)

#### 2.Private-vm

- Name: private-vm

- Zone: us-central1-a

- Machine type: e2-micro

- Boot disk: Debian

- Firewall: No options need checking

- Networking > Network interfaces

   - Network: ranjitha-tf-vpc

   - Subnet: private-subnet

   - External IP: **None**

Click Create

#### Step F: Test Connectivity

#### Method 1:
- SSH into Public VM:
```
gcloud compute ssh public-vm --zone=us-central1-a
```
From inside public-vm, connect to private-vm:
```
ssh <private-vm-internal-ip>
```
Method 2:

- Generate keypair and copy keys to public-vm..From public vm copy public key to private vm.Then

- SSH into the public VM
```
ssh username@public_vm_ip
```
- SSH to private vm
```
ssh -i ~/.ssh/id_rsa username@private_vm_ip
```
![image](https://github.com/user-attachments/assets/59fc2fc4-7c7f-486c-8dbd-70b424ccc897)
