
# Connecting Virtual Machine's through Bastion 

### Architecture Diagram
![Screenshot from 2024-12-29 20-48-57](https://github.com/user-attachments/assets/4bcd2f0a-3fad-4236-b3fd-835df3fe045b)




Refer [Task-1](https://github.com/Ranjitha75388/projects/blob/main/Azure/Task-1%20(Connect%20vm%20-%20SSH).md)
### Roadmap:

- Create resource group
- Create Bastion-virtual machine,Disk
- Create webtier-virtual machine,Disk
- connect Bastion virtualmachine via Bastion 
- Connect webtier vm with bastion vm

### Step by step process

### Step1 : Create resource group

  -  Resource group Name:rg-ranjitha-Bastion


### Step2 : Create Virtual network

- #### Create New --> Vnet Name(vnet-Bastion)

![Screenshot from 2024-12-30 22-14-48](https://github.com/user-attachments/assets/2a1104c0-35b2-4ab7-8de8-d17a632e8875)


- #### Vnet Address range --> Subnets(1.Bastionmachine-subnet,2.Webmachine-subnet)

![Screenshot from 2024-12-30 22-27-37](https://github.com/user-attachments/assets/490d6345-06e7-48e1-ae8e-b5f1aa4f0689)

- ### Review and Create

### Step3 : Create Virtual Machine_1 (Bastion machine)

![Screenshot from 2024-12-30 22-30-58](https://github.com/user-attachments/assets/57d3adbe-d867-4e27-bf8c-ef3d9c0c140e)

  - Administrator account

![Screenshot from 2024-12-30 22-32-07](https://github.com/user-attachments/assets/2bff5bbd-3daf-478a-9eac-52c9f6e8f42c)


- #### Networking

    - Virtual network(Vnet-bastion) --> Subnet(Bastionmachine-subnet) --> Public IP (Need to connect from User) ---> NIC NSG(Basic) --> ports(Allow)
   ![Screenshot from 2024-12-30 22-34-24](https://github.com/user-attachments/assets/2bea4191-2efb-49cd-a7bd-f8446958d072)

- #### Review and Create


### Step4: Create virtual machine_2 (Webtier machine)

   - #### Instance details

     Virtual machine name:Webtier-virtual machine

  - #### Networking

     subnet(Webmachine-subnet) --> Public IP:**NONE**(need to connect privately only to bastion machine)
   ![Screenshot from 2024-12-30 22-35-23](https://github.com/user-attachments/assets/1d94cadb-9d52-48ca-ad62-33dbaefcbe06)

  - #### Review and Create

### Step5 : Connect Bastion

  - Open Bastion-virtualmachine -->Connect (Connect via Bastion)
  - Automatically terminal opened ,connecting with Bastion machine
  - From Bastion machine : webmachine connect with private IP Address

     ```
       ssh ranjitha@(Private IP of webtier-vm)
     ```
   ![Screenshot from 2024-12-28 15-23-29](https://github.com/user-attachments/assets/0e7605e8-4d15-486b-8153-c3f4137aa069)
