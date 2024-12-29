
# Connecting Virtual Machine's through Bastion 

### Architecture Diagram

  ![image](https://github.com/user-attachments/assets/87eba901-dee3-4a47-a53a-651f93ef5aaf)  ![Screenshot from 2024-12-29 19-48-32](https://github.com/user-attachments/assets/2e5c674d-8a81-4d5e-ba87-4e8296eea575)


Refer [Task-1](https://github.com/Ranjitha75388/projects/blob/main/Azure/Task-1%20(Connect%20vm%20-%20SSH).md)
### Roadmap:

- Create resource group
- Create Bastion host,Vnet,subnet,NSG
- Create Bastion-virtual machine,Disk
- Create webtier-virtual machine,Disk
- connect Bastion virtualmachine via Bastion 
- Connect webtier vm with bastion vm

### Step by step process

### Step1 : Create resource group

  -  Resource group Name:rg-ranjitha-Bastion

### Step2 : Create Bastion

- ### Project Details
    
    Create --> Subscription (Free Trail) --> resourse group(rg-ranjitha-Bastion) 

- ### Instance details
  
    Name(Bastion-host) --> Region(central india)

- ### Configure Virtual network

   Create New -->Vnet Name(vnet-Bastion) --> Vnet Address range --> Subnets(1.Azurebastionsubnet,2.Bastionmachine-subnet,3.Webmachine-subnet)

- ### Configure IP Address   
   
    Public ip address 

  - ###  Public IP address
   
     Create new --> IP address Name

- ### Review and Create

### Step3 : Create Virtual Machine_1 (Bastion machine)

- #### Basics
  - ProjectDetails
    
    Subscription:Free Trail
    
    Resource Group:rg-ranjitha-Bastion

  - Instance Details
    
     Virtual Machine Name: Bastion-virtual-Machine

  - Administrator account

     Password type --> Username(ranjitha) --> Password(Tharshik@123)

- #### Networking

    - Virtual network(Vnet-bastion) --> Subnet(Bastionmachine-subnet) --> Public IP (Need to connect from User) ---> NIC NSG(Basic) --> ports(Allow)

- review and Create


### Step4: Create virtual machine_2 (Webtier machine)

   - Instance details

     Virtual machine name:Webtier-virtual machine

  - Networking

     subnet(Webmachine-subnet) --> Public IP:NONE(need to connect privately only to bastion machine)

  - Review and Create

### Step5 : Connect Bastion

  - Open Bastion-virtualmachine -->Connect (Connect via Bastion)
  - Automatically terminal opened ,connecting with Bastion machine
  - From Bastion machine : webmachine connect with private IP Address

     ```
       ssh ranjitha@(Private IP of webtier-vm)
     ```
   ![Screenshot from 2024-12-28 15-23-29](https://github.com/user-attachments/assets/0e7605e8-4d15-486b-8153-c3f4137aa069)
