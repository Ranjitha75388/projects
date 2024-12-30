
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

  -  **Resource group Name**:rg-ranjitha-Bastion


### Step2 : Create Virtual network


![Screenshot from 2024-12-30 22-40-52](https://github.com/user-attachments/assets/b2b80dc6-b079-42f3-936e-33f06db95d3f)

- #### Vnet Address range --> Subnets(1.Bastionmachine-subnet,2.Webmachine-subnet)

![Screenshot from 2024-12-30 22-27-37](https://github.com/user-attachments/assets/490d6345-06e7-48e1-ae8e-b5f1aa4f0689)

- ### Review and Create

### Step3 : Create Virtual Machine_1 (Bastion machine)

![Screenshot from 2024-12-30 22-30-58](https://github.com/user-attachments/assets/57d3adbe-d867-4e27-bf8c-ef3d9c0c140e)

  - Administrator account

![Screenshot from 2024-12-30 22-32-07](https://github.com/user-attachments/assets/2bff5bbd-3daf-478a-9eac-52c9f6e8f42c)


- #### Networking

    - Virtual network(bastion-service) --> Create 2 Subnets(Bastionmachine-subnet) --> Public IP (Need to connect from User) ---> NIC NSG(Basic) --> ports(Allow)

    ![Screenshot from 2024-12-30 22-34-24](https://github.com/user-attachments/assets/2bea4191-2efb-49cd-a7bd-f8446958d072)

- #### Review and Create


### Step4: Create virtual machine_2 (Webtier machine)

  ![Screenshot from 2024-12-30 22-44-14](https://github.com/user-attachments/assets/ba66f207-d1a8-473e-a663-2ec50ae136e6)

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
