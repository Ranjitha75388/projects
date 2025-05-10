### Step1:Resourse group

Select the same resourse group used for frontend,backend (rg-ranjitha-3tier-app)

### Step2: Select Vnet

Select vnet created previously as (v-net-3tier)

### Step3:Create private subnet with NSG and select NAT Gateway created in backend

![image](https://github.com/user-attachments/assets/aeda767a-1b4e-4550-953f-48b9face6b89)
![image](https://github.com/user-attachments/assets/f873882a-a894-4e67-a52e-5e8c9a85aab5)

### Step4:In network settings add inbound rules

Only backend vm's private ip should allow with database vm

![image](https://github.com/user-attachments/assets/f4e77e74-858a-4439-a9f9-8994d4fbebd1)

### Step4:Create vm

![image](https://github.com/user-attachments/assets/7fbae074-a12c-425c-812d-72a433f90980)
![image](https://github.com/user-attachments/assets/6e1097c9-2bf9-41ee-a43f-ae6cd18d514a)

**Next:Networking --->No need public ip,no need NSG(NSG is created subnet level)**

![image](https://github.com/user-attachments/assets/e9ebd14d-5088-4a4b-a1f7-1b293b32abca)

### Step5:In terminal login to frontend vm,then login to backend vm.From backend login in to database vm with private ip
```
ssh ranjitha@10.0.3.4
```

If user is not created,create as below
```
CREATE USER (username)'root'@'%' IDENTIFIED BY (password)'ranjitha';
GRANT ALL PRIVILEGES ON *.* TO 'root_remote'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
Exit
```
### Create Database
```
 sudo mysql -u username -p
 CREATE DATABASE databasename(mynewdatabase);
```
After creating user as 'root' 

![image](https://github.com/user-attachments/assets/82fe3029-1cf6-4ca1-8088-1c4c8150dbd8)

![image](https://github.com/user-attachments/assets/6e131392-ed21-4fec-a12f-b6f6ef4ed7fa)

### Step6:Check database is conneccted with backend
```
ping 10.0.3.4
```
### Step7:Check mysql is connected with backend
From backend vm check this
```
mysql -h 10.0.3.4 -u root -p
```
#### Edit the MySQL configuration file (/etc/mysql/mysql.conf.d/mysqld.cnf or /etc/my.cnf) and verify that the bind-address is set to either 0.0.0.0 (to accept connections from any IP address) or 10.0.3.4 

bind-address = 0.0.0.0
### NOTE:
In this project data will not enter in table.bacause submit button will not work,bacause of backend vm doesnot connect with loadbalancer.
