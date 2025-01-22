
# Deploy Backend vm

### Step1: Select resourse group created in frontend

(rg-ranjitha-3tier-app)

### Step2 :Create NAT (network address translation) gateways

![image](https://github.com/user-attachments/assets/042ab913-9ed5-4e9b-95db-376580341b4d)

**Next:outboundIP**

![image](https://github.com/user-attachments/assets/a490b9a6-4055-43f0-b483-411ac80020f4)


### Step3 :Select Vnet(v-net-3tier) as created in frontend.

### Step4 :Create private subnet with NSG and NAT Gateways

![image](https://github.com/user-attachments/assets/907a9ea3-edfa-4cfd-91b6-0faafe1a025c)

### Add inbound rules:frontend public-ip to backend private-ip

![image](https://github.com/user-attachments/assets/ef2ae659-af00-4712-a194-50d72057073a)

### Add inbound rule : backend private-ip to database private-ip

![image](https://github.com/user-attachments/assets/57c15c6c-d1c2-4c38-8cd0-2d99bb8fca93)


### Step5 :Create virtual machine

![image](https://github.com/user-attachments/assets/7f5d946b-7a22-4b80-8f5d-f5160772cb3f)

**Next:Networking:no need public ip,no need NSG for vm**

![image](https://github.com/user-attachments/assets/c996e095-1606-46e1-afdc-5ed30cf92a15)


### Step6 :Copy ems-phase backend folder from local to frontend vm

First copy spring boot folder from local to frontend vm
```
scp -r /home/logi/Downloads/old-files/ems-ops-phase-0/springboot-backend ranjitha@20.198.23.54:/home/ranjitha
```
Next copy springboot folder from frontend vm to backend vm
```
 scp -r /home/ranjitha/springboot-backend/ ranjitha@10.0.2.4:/home/ranjitha/
```
### Step7: move to backend vm from frontend vm

![image](https://github.com/user-attachments/assets/c5f5df22-1ca4-49fa-985c-11669a7b09ad)


### Step7 :Install java-17
```
    sudo apt install openjdk-17-jdk -y
```
### Step8 :Install maven
```
   sudo apt update

   sudo apt install maven
```
### Step9 :Add Database vm private ip
```
   nano/src/main/resourse/application properties
```
```
spring.datasource.url=jdbc:mysql://10.0.3.4:3306/mynewdatabase?useSSL=false&allowPublicKeyRetrieval=true
spring.datasource.username=ranjitha
spring.datasource.password=123
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQLDialect
spring.jpa.hibernate.ddl-auto=update

```   
### step10 :Clean and build the application
```
   mvn clean install -DskipTests
```
![image](https://github.com/user-attachments/assets/201f516f-5cf7-4011-a41f-d1e30f0a3e16)


### Step11 :check target folder after build the application
![image](https://github.com/user-attachments/assets/ff06ce27-2ae6-44d7-8f61-d3ad1cef4ecd)


### Step12 :Run the jar file inside target folder.
```
   java -jar springboot-backend-0.0.1-SNAPSHOT.jar
```
![image](https://github.com/user-attachments/assets/fb4bdebd-d207-459d-b804-0421abc8b97c)

# NOTE:
By using this requirement submit button will not work in browser.we need to add load balancer between frontend subnet and backend subnet.
