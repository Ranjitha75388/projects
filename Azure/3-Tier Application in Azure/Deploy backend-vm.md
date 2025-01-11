
# Deploy Backend vm

### Step1: Select resourse group(rg-ranjitha-3tier-app) create in frontend

### Step2 :Create NAT (network address translation) gateways

### Step3 :Select Vnet(v-net-3tier) as created in frontend.

### Step4 :Create private subnet with NSG and NAT Gateways

### Step5 :reate virtual machine

### Step6 :Copy ems-phase backend folder from local to frontend vm

### Step7 :Copy backend folder from frontend vm to backend vm

### Step8 :Install java-17
```
    sudo apt install openjdk-17-jdk -y
```
### Step9 :Install maven
```
   sudo apt update

   sudo apt install maven
```
### Step10 :Add Database vm private ip
```
   cd /src/main/resourse/application properties



```   
### step11 :Clean and build the application
```
   mvn clean install -DskipTests
```
![image](https://github.com/user-attachments/assets/201f516f-5cf7-4011-a41f-d1e30f0a3e16)


### Step12 :check target folder after build the application
![image](https://github.com/user-attachments/assets/ff06ce27-2ae6-44d7-8f61-d3ad1cef4ecd)


### Step13 :Run the jar file inside target folder.
```
   java -jar springboot-backend-0.0.1-SNAPSHOT.jar
```
![image](https://github.com/user-attachments/assets/fb4bdebd-d207-459d-b804-0421abc8b97c)


