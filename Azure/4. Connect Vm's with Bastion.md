
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

 **Resource group Name** : rg-ranjitha-Bastion


### Step2 : Create Virtual network


![Screenshot from 2024-12-30 22-40-52](https://github.com/user-attachments/assets/b2b80dc6-b079-42f3-936e-33f06db95d3f)

 #### Next :  IP Address 

 - Create two subnets(Bastionmachine subnet and webmachine subnet)

![Screenshot from 2024-12-30 22-27-37](https://github.com/user-attachments/assets/490d6345-06e7-48e1-ae8e-b5f1aa4f0689)

- #### Review and Create

### Step3 : Create Virtual Machine_1 (Bastion machine)

![Screenshot from 2024-12-30 22-30-58](https://github.com/user-attachments/assets/57d3adbe-d867-4e27-bf8c-ef3d9c0c140e)

![Screenshot from 2024-12-30 22-32-07](https://github.com/user-attachments/assets/2bff5bbd-3daf-478a-9eac-52c9f6e8f42c)


#### Next: Networking

- Virtual network(bastion-service) --> Subnets(Bastionmachine-subnet) --> **Public IP** (Need to connect from User)
 --> NIC NSG(Basic) --> ports(Allow)

 ![Screenshot from 2024-12-30 22-34-24](https://github.com/user-attachments/assets/2bea4191-2efb-49cd-a7bd-f8446958d072)

- #### Review and Create


### Step4: Create virtual machine_2 (Webtier machine)


  ![Screenshot from 2024-12-30 22-44-14](https://github.com/user-attachments/assets/ba66f207-d1a8-473e-a663-2ec50ae136e6)


 #### Next: Networking


 - subnet(Webmachine-subnet) --> Public IP: **NONE** (need to connect privately only to bastion machine)
  
 ![Screenshot from 2024-12-30 22-35-23](https://github.com/user-attachments/assets/1d94cadb-9d52-48ca-ad62-33dbaefcbe06)

  - #### Review and Create

### Step5 : Connect Bastion

  - Open Bastion-virtualmachine -->Connect (Connect via Bastion)
  
  ![Screenshot from 2024-12-31 12-46-12](https://github.com/user-attachments/assets/fc58bb32-0b3a-4645-8d49-57ed33e033c4)

 - Automatically terminal opened ,connecting with Bastion machine
  - From Bastion machine : webmachine connect with private IP Address

     ```
       ssh ranjitha@(Private IP of webtier-vm)
     ```
   ![Screenshot from 2024-12-28 15-23-29](https://github.com/user-attachments/assets/0e7605e8-4d15-486b-8153-c3f4137aa069)

- ###  Another method to enter to web vm

- Create BAstion vm using Generate new key pair
![Screenshot from 2025-01-03 22-03-28](https://github.com/user-attachments/assets/683f0401-cda6-40d1-8776-5d46db378e07)

  
- Create web vm --> SSH type keypair --> In Networking - subnet - enable **private subnet**
![Screenshot from 2025-01-03 22-04-26](https://github.com/user-attachments/assets/cff410ea-b0a5-4a16-bbae-6c4c18585e30)

![Screenshot from 2025-01-03 22-05-36](https://github.com/user-attachments/assets/4f59657e-6474-4159-911a-03e57af2b575)

- Run the below command in terminal 

   eval "$(ssh-agent -s)"

  ssh-add /path/to/your/private-key

  ssh -A azureuser@<BastionPublicIP>

   ssh azureuser@<WebVMPrivateIP>
 


   ![Screenshot from 2025-01-03 21-48-23](https://github.com/user-attachments/assets/6845bd79-b232-4286-9acd-fa8755b4fba5)

   ![Screenshot from 2025-01-03 21-50-20](https://github.com/user-attachments/assets/13034ea9-f138-4813-8e43-ca56afb7abe8)


   ![Screenshot from 2025-01-03 21-50-57](https://github.com/user-attachments/assets/91058ea5-26ea-40d8-9789-17ea47e102d8)
