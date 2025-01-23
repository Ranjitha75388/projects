
# 3-Tier Application in Azure

![Screenshot from 2025-01-05 11-46-52](https://github.com/user-attachments/assets/503c4dee-1095-48a6-8952-4ad83f696918)









## 1. Create a Resource Group
   
• Open the Azure Portal.
  
• Go to Resource Groups > Create.
       
   - Resource group name: rg-ranjitha

## 2.Create Virtual network

• Go to Virtual Networks > Create.
    
   -  Name: e.g :Vnet
  
 -  Region: Same as the resource group.
   
   - Address Space: e.g: 10.0.0.0/16 

• Click Next: Subnets.

## 3.Create subnets
   
• In the Subnets tab, 
    
- Public Subnet:
     
    ▪ Name: public subnet-1

    ▪ Address Range: 10.0.1.0/24

- Private Subnet (Back-End):
    
    ▪ Name: private subnet-2

    ▪ Address Range: 10.0.2.0/24
    
- Private Subnet (Database):

    ▪ Name: private subnet -3

    ▪ Address Range: 10.0.3.0/24

## 4. Deploy Network Security Groups (NSG)

• Go to Network Security Groups > Create for each subnet:
      
   - NSG for Public Subnet:
         
       ▪ Allow inbound traffic on port 3000 from any source.


   - NSG for Back-End and Database Subnets:
       
       • Allow inbound traffic from Public Subnet (10.0.1.0/24) to Back-End Subnet.
      
       • Allow inbound traffic from Back-End Subnet (10.0.2.0/24) to Database Subnet.

## 5.Create Virtual MAchines
    
◦ Go to Virtual Machines > Create.
    
   - Select:
   
       ▪ Region: Same as the VNet.

       ▪ Image: Choose OS (e.g., Ubuntu)

       ▪ Authentication: Use SSH key or password.
   
   - Networking:
    
       - Subnet: Assign the VM to the appropriate subnet:

        ◦ VM1: public subnet-1 (Front-End)

        ◦ VM2: private subnet-2 (Back-End)

        ◦ VM3: private subnet-3 (Database)

• Attach the NSG for the respective subnet.

◦ For VM1, assign a public IP.

• Click Review + Create > Create.
               
## 6. Configure VM Networking
  
• For VM1 (Front-End):

  - Open the NSG > Inbound Security Rules.
  
- Add a rule to allow traffic on port 3000 from any source.

• For VM2 (Back-End):

 - Ensure only traffic from 10.0.1.0/24 (Public Subnet) is allowed.

• For VM3 (Database):

   - Ensure only traffic from 10.0.2.0/24 (Back-End Subnet) is allowed.
