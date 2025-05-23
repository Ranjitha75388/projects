# Architecture for networking


                                   +------------------+
                             |     Internet     |
                             +--------+---------+
                                      |
                    [ External IP: 35.XXX.XXX.10 ]
                                      |
                            SSH / HTTP / HTTPS
                                      |
                             +--------v---------+
                             |     my-vpc       |
                             |   Custom VPC     |
                             |   10.0.0.0/16    |
                             +--------+---------+
                                      |
        +-----------------------------+------------------------------+
        |                             |                              |
+-------v--------+           +--------v--------+           +--------v--------+
| Public Subnet  |           | Private Subnet  |           |   DB Subnet     |
| 10.0.1.0/24    |           | 10.0.2.0/24     |           | 10.0.3.0/24     |
+-------+--------+           +--------+--------+           +--------+--------+
        |                             |                              |
+-------v--------+           +--------v--------+           +--------v--------+
|   public-vm    |           |   private-vm    |           |  Cloud SQL DB   |
| Int IP: 10.0.1.10 |        | Int IP: 10.0.2.10 |        | Int IP: 10.0.3.10 |
| Ext IP: 35.XXX.10 |        | No External IP    |        | No External IP    |
+------------------+         +-------------------+        +------------------+
                                     |
                           +---------v---------+
                           |   Cloud Router    |
                           +---------+---------+
                                     |
                           +---------v---------+
                           |     Cloud NAT     |
                           +-------------------+
                                     |
              (Optional Internet Egress for private-vm via NAT)

                           























                         

### Goal:

Set up a secure custom VPC network with:

- Public subnet: VM has external IP, accessible from internet

- Private subnet: VM has no external IP, only communicates internally or via NAT

- Private VM can access internet via NAT (optional)

- Firewall rules for secure access

- Private VM can only be accessed through Public VM

## Step A: Create VPC Network

- In console > Search VPC networks

- Click "Create VPC network"

    - **Name**: ranjitha-tf-vpc

    - **Subnet creation mode**: Custom

     - **Dynamic routing mode**:Regional 

## Step B: Create Subnets

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

## Step C: Create Firewall Rules

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

4.Allow Private vm to MYSQL

(Optional refer:3 Targets: All instances in the network)

   - **Name**               :  `allow-mysql-access`                   
   - **Network**             : `ranjitha-tf-vpc`                      
   - **Direction**            :`Ingress`                              
   - **Action**               :`Allow`                                
   - **Source IP ranges**     :`10.0.0.0/24` (your private VM subnet) 
   - **Target IP ranges**     :`10.127.0.4/32` (your Cloud SQL IP)    
   - **Protocols and Ports**  :`tcp:3306`                             

## Step D: Setup Cloud Router + NAT (only if private VM needs internet)

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

##  Step E: Create VM Instances

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

## Step F: Test Connectivity

- Generate keypair and copy keys to public-vm from local machine..From public vm copy public key to private vm.Then

- SSH into the public VM
```
ssh username@public_vm_ip
```
or
```
gcloud compute ssh public-vm --zone=us-central1-a
```
- SSH to private vm
```
ssh -i ~/.ssh/id_rsa username@private_vm_ip
```
    ![image](https://github.com/user-attachments/assets/59fc2fc4-7c7f-486c-8dbd-70b424ccc897)

## Step G: Create private service access

To create private connections to Google services (like Cloud SQL using Private IP), we must first allocate an internal IP range and then set up a Private Services Access (PSA) connection to our VPC.

#### Step 1: Allocate IP Range for Private Services Access

- Go to VPC network > VPC networks in the GCP Console.

- Click on your network (e.g., ranjitha-tf-vpc).

- In the left menu, click Private service connection.

- Click Allocate IP range.

- Fill in:

    - Name: private-seervice-ip

    - Region: Choose your region (e.g., us-central1)

    - IP range: custom:e.g., 10.10.0.0/16 (must not overlap with our VPC subnets)
      Automatic :eg:16

- Click Allocate.

   ![image](https://github.com/user-attachments/assets/ad718d79-4027-4905-951b-1a6bdd08cec5)


#### Step 2: Create Private Connection Using the IP Range

 - In the same Private service connection page, click Create connection.

 - Select:
    
     - Connected service provider:Google cloud platform.
    
     -  Allocated allocation: Choose psa-ip-range (from above)

  - Click Create connection.

   ![image](https://github.com/user-attachments/assets/6640df0b-aac7-4312-be00-a3f0c26eb6b3)


##  Step H:Create Cloud SQL with Private IP

- Go to cloud sql : create instance
- Choose your database engine :MYSQL

   ![image](https://github.com/user-attachments/assets/67f1d09f-0396-4f01-9516-312de6d3c641)
- Create a MYSQL Instance

  #### 1. Instance Basics

   -  Edition Preset: Production

   -  Database Version: MySQL 8.0

    - Instance ID: gcp-mysql-db

    - Root Password: StrongP@ssword123!

  #### Region & Availability

    - Region: us-central1

    - Zonal Availability: Multiple zones (Highly Available)
 
  #### Machine Configuration

   - Machine Type: N2 - 4 vCPU, 32 GB RAM

   - Storage Type: SSD

   - Storage Capacity: 250 GB

   - Enable Automatic Storage Increases

#### Networking

  - IP Assignment: Private IP

  - VPC Network: ranjitha-tf-vpc

  - Private Services Access (PSA): Enabled (required)

  - No Public IP (for security)

  - Authorized Networks Enable(for SQL Proxy or private access)

- Create Instance
  
![image](https://github.com/user-attachments/assets/16e20f36-6fc0-4c12-af21-1fd68effd7a1)

#### Use a MySQL command in terminal:
```
mysql -h 10.127.0.4 -u root -p
```

