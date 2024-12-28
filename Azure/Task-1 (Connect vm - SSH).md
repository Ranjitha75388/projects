# Connected to virtual machine using SSH

## Architecture Diagram

![image](https://github.com/user-attachments/assets/57d3ff5d-812e-4d48-9f38-9e056a9aec51)

## Roadmap:
- Create Resourse group
- Create virtual Network
- Create subnet with NSG inside Virtual Network
- create virtual machine,Disk,NSG inside subnet
- Access virtual machine from local machine in terminal
- User connected to web vm-1 through port 22 with virtual machines public id.

## Step by step process

### Step 1:Create resource Group
     
- Resourse group name:rg Ranjitha

### Step 2: Create Virtual Network

- Subscription(Free trail) --> Resourse group(rg Ranjitha) --> Virtual network name (vnet1) --> region(Central india)

- IP address -->10.10.0.0/16 -->Add subnet(CIDR Calculator) --> NSG(add name) --> Review and create.

  ![Screenshot from 2024-12-28 21-50-22](https://github.com/user-attachments/assets/0158b57b-8266-41ff-93fd-fcf155c8cba6)



- Virtual Network and NSG creted.

  - NSG --> Right corner settings --> Inbound security rules --> Add --> port(22),protocol(TCP),Action(Allow),priority(lessnumber).
  - Check in Overview --subnet(1) --> Network Interfaces --> subnets.

### Step 3:Create Virtual Machine

-    virtualmachine --> create -->subscription(Free Trail) -->Resourse group(rg ranjitha) -->vm name(vm-1) --> Image(Ubuntu22) -->VM Architecture(X64) -->Size(1vcpu,1Bitmemory)

-   Authentication type
      - Username:ranjitha
      - SSH Publickey -->Username ,Generate new keypair,keypair name(vm-1-keypair)
      - port --> SSH(22)

### Step 4:Create Disk

 -  For image Ubuntu(22) Default Size(30Gib) added

### Step 5:Create Networking

 - Default vnet,subnet added (created above step:2)
 - Need Public key (ip address)
 - NSG (Basic)
 - Delete public-ip and NIC when VM is deleted(Tick)

### Step 6:Review and create --> DOWNLOAD PRIVATEKEY.

## ACCESS VIRTUAL MACHINE FROM LOCAL TERMINAL

- Check (vm-keypair.pem) file in Downloads
- Copy .pem file to home/logi directory
- Give read and write permissions only

    ```bash
      ssh -i vm-1-keypair.pem ranjitha@(public ip-address of virtual machine)
     ```
- Connected to Virtual machine

  ![Screenshot from 2024-12-27 16-59-00](https://github.com/user-attachments/assets/25862e04-b38e-43c2-93e0-be7296e34857)







