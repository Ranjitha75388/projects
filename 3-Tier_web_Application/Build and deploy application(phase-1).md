# Build, and Manual Deployment of the Full stack web Application (phase-1)

This phase guides to setup and build the frontend and backend services and run it on local machine manually.

Before build the application Pre-requisites installation should be done.Follow the `Phase 0` https://github.com/Ranjitha75388/Jumisa-Technology/blob/main/3-Tier%20web%20Application/Prerequisites%20Installation%20(phase-0).md
 

### Step1 : Unzip the file

- Unzip file was given by team. 'ems-ops-phase-0.zip'
- Use the cd command to change to the Downloads directory (or wherever your ZIP file is located)
    ```
        cd ~/Downloads
    ```
- Use the unzip command followed by the name of your ZIP file to extract it.
     ```
        sudo apt install unzip
        unzip filename.zip -d /path/to/destination/
    ```
-  After extract the zip file
    ```
        cd/ems-ops-phase-0/
- After extracting, you might want to move into project directory (springboot-backend) is a subdirectory created during extraction.
    ```
        cd /home/logi/Downloads/ems-ops-phase-0/springboot-backend
    ``` 
### Step2 : Update Application Properties 

This directory contains details of `Database`.Have to update the Databasename, username,password that we have created in phase 0.
    
```
        sudo nano src/main/resources/application.properties
```
```        
        spring.datasource.url=jdbc:mysql://localhost:3306/mynewdatabase?useSSL=false&allowPublicKeyRetrieval=true
        spring.datasource.username=root
        spring.datasource.password=ranjitha
        spring.jpa.properties.hibernate.dialect = org.hibernate.dialect.MySQLDialect
        spring.jpa.hibernate.ddl-auto = update
```
### Step3 : Maven package init

- pom.xml` contains all the package and its dependencies. To install them all we use maven tool.Check the necessary dependencies added and its version.
```
        sudo nano pom.xml
```
- Remove previously compiled files and ensure a fresh build.
```
        mvn clean
```
## Step4 : Build the backend

- Build and package the application . This will generate a `target` folder under `springboot-backend`  and `*.jar` file will be generated.
```
        mvn install
```
### step5 : check the .jar file under target directory.
```
        cd /home/logi/Downloads/ems-ops-phase-0/springboot-backend/target
        ll
```
- see the 'springboot-backend-0.0.1-SNAPSHOT.jar' file located in target folder. 
- Generated `jar` file is the packaged application and that can be executed by `java` or any webservers like `tomcat` . By default the application runs on port `8080`
### Step6 : Run the Application
Run the jar file from the target folder.
```
        java -jar springboot-backend-0.0.1-SNAPSHOT.jar
```
After execution of this command see the status as 'springboot Application started'

![Screenshot from 2024-12-03 16-56-56](https://github.com/user-attachments/assets/1e96f124-d657-481f-8495-e94a345c14b7)

## Step7 : Frontend Setup
```
        cd /home/logi/Downloads/ems-ops-phase-0/react-hooks-frontend
```
### Step8 : Build the frontend
To Get the packages and dependencies ,which will store them under `node_modules` folder.
```
        npm install
```
### Step9 : Run the Application
```
        npm start
```
By default the application runs on port `3000` 

![Screenshot from 2024-11-24 20-01-18](https://github.com/user-attachments/assets/a950226d-73ca-4c66-b0f5-c8bb6a50d2ac)

### Step10 : Accessing App in the Browser
URL to access the Application
http://localhost:3000

Now you will receive Employee-list.In that list ,Add-employee details.submit it.and can update details.

![Screenshot from 2024-11-24 19-55-39](https://github.com/user-attachments/assets/7ec34620-af0b-4095-bf67-57dee4327aba)

![image](https://github.com/user-attachments/assets/f2e73d8f-e4c9-41a7-8682-8d7523421f44)

### ERROR
![Screenshot from 2024-11-26 14-52-24](https://github.com/user-attachments/assets/565030f9-1466-4b8a-a11b-e2d6b2d1c832)
### Solution
Check if any other application is running on that port.
```
   sudo lsof -i:8080
   sudo kill -9:PID
```



