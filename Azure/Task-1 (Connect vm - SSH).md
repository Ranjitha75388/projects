# Connected to virtual machine using SSH

## Architecture Diagram

![Screenshot from 2024-12-29 21-02-54](https://github.com/user-attachments/assets/4d90e795-b58c-46ab-ad07-1c1d423cfa0a)

[Basic Information](https://github.com/Ranjitha75388/projects/blob/main/Azure/Subscription%2CResourse%20Group%2CResources.md)
## Roadmap:
- Create Resourse group
- Create virtual Network
- Create subnet with NSG inside Virtual Network
- create virtual machine,Disk,NSG inside subnet
- Access virtual machine from terminal
- User connected to web vm-1 through port 22 with virtual machines public id.

## Step by step process

## Step 1:Create resource Group
     
   ![Screenshot from 2024-12-30 12-06-12](https://github.com/user-attachments/assets/31db56ea-7237-4380-9392-48794973621c)

  #### Review+create

## Step 2: Create Virtual Network

  ![Screenshot from 2024-12-30 12-35-14](https://github.com/user-attachments/assets/4156d79f-389a-4fa8-9db0-50f9d2414055)

  ### Next

- ### IP address  --> Add subnet(CIDR Calculator) -->  Review and create.

  ![Screenshot from 2024-12-30 12-40-40](https://github.com/user-attachments/assets/f1058e57-3c5b-4fb9-af50-6204b346be7e)

- ### In Add subnet --> Security -->Network security group

   ![Screenshot from 2024-12-30 13-17-02](https://github.com/user-attachments/assets/9260d70a-e1a4-441b-a0ab-670176de736b)


  ![Screenshot from 2024-12-28 21-50-22](https://github.com/user-attachments/assets/0158b57b-8266-41ff-93fd-fcf155c8cba6)

- ### To Check NSG
- #### Right corner settings --> Inbound security rules --> Add --> port(22),protocol(TCP),Action(Allow),priority(lessnumber).

  ![Screenshot from 2024-12-30 12-53-17](https://github.com/user-attachments/assets/fb4014d9-0dd5-421d-b3b1-949e3630c573)


  ## Step 3:Create Virtual Machine

- #### virtualmachine --> create -->subscription(Free Trail) -->Resourse group(rg ranjitha) -->vm name(vm-1)

   ![Screenshot from 2024-12-30 21-10-47](https://github.com/user-attachments/assets/e5d3046b-acec-47bc-9ae4-9a9bea39faf4)

- #### Image(Ubuntu22) -->VM Architecture(X64) -->Size(1vcpu,1Bitmemory)

    ![Screenshot from 2024-12-30 21-30-46](https://github.com/user-attachments/assets/df76d841-f762-4aa4-b682-796e823a08db)


- #### Authentication type

    ![Screenshot from 2024-12-30 21-13-16](https://github.com/user-attachments/assets/3f35e99d-6d9c-4f24-8cb3-b66e49da8955)

-  #### (or)password type

    ![Screenshot from 2024-12-30 21-14-35](https://github.com/user-attachments/assets/3d3015d4-b884-412b-b509-4c6d277e3de2)

 - #### port
 
    ![Screenshot from 2024-12-30 21-15-32](https://github.com/user-attachments/assets/486a6033-c27f-4a16-bf0d-b93c7be21a14)


### Step 4:Create Disk

-  For image Ubuntu(22) Default Size(30Gib) added

### Step 5:Create Networking

 - Default vnet,subnet added (created above step:2)
 - Need Public key (ip address)
 - NSG (Basic)
 - Delete public-ip and NIC when VM is deleted(Tick)

![Screenshot from 2024-12-30 21-18-57](https://github.com/user-attachments/assets/a0dd2a6f-6f2d-4e1e-b171-3aa9980baf03)

### Step 6:Review and create --> DOWNLOAD PRIVATEKEY.

## ACCESS VIRTUAL MACHINE FROM TERMINAL

- Check (vm-keypair.pem) file in Downloads
- Copy .pem file to home/logi directory
- Give read and write permissions only
    ```
       sudo chmod 600 vm-1-keypair.pem
    ```
    ```bash
      ssh -i vm-1-keypair.pem ranjitha@(public ip-address of virtual machine)
     ```
- #### Connected to Virtual machine

  ![Screenshot from 2024-12-27 16-59-00](https://github.com/user-attachments/assets/25862e04-b38e-43c2-93e0-be7296e34857)







