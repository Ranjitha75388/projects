      

# Daemonize the services in Azure 

Step 1: After running npm start in frontend vm,To get the build folder
```
npm run build
```
Step 2: mkdir opt

Step 3: cd opt  :    mkdir react-frontend

Step 4: copy build folder to react-frontend

```
 cp -r /home/ranjitha/react-hooks-frontend/build /home/ranjitha/opt/react-frontend/

``` 
Step 5: Install `serve` node package
```
  npm install -g serve
```  


Step 6: mkdir etc

Step 7: cd etc:mkdir systemd

Step 8: cd systemd:mkdir systemd

Step 9: cd systemd:mkdir reactapp_ems.service


Step 10:Create `SystemD` Service
```
sudo nano  /etc/systemd/system/reactapp_ems.service
```
```
[Unit]
        Description=StudentsystemApplication React service
        After=syslog.target network.target

    [Service]
        SuccessExitStatus=143
        User=ranjitha
        Type=simple
        Restart=on-failure
        RestartSec=10

        WorkingDirectory=/home/ranjitha/opt/react-frontend/
        ExecStart=serve -s build -l tcp://0.0.0.0:3000
        ExecStop=/bin/kill -15 $MAINPID

    [Install]
        WantedBy=multi-user.target

```
 #### Daemon Reload & systemctl cmd

sudo systemctl daemon-reload

sudo systemctl start reactapp_ems.service

sudo systemctl status reactapp_ems.service

![image](https://github.com/user-attachments/assets/830e8152-419b-44d7-abaf-ac0758dfe083)


# Springboot backend

Step 1: mkdir opt

Step 2: cd opt:mkdir java-backend

```
 cp -r /home/ranjitha/springboot-backend/target/springboot-backend-0.0.1-SNAPSHOT.jar /home/ranjitha/opt/java-backend/
```

Step 3: mkdir etc

Step 4: cd etc:mkdir systemd

Step 5: cd systemd:mkdir system

Step 6: cd system:mkdir  app_ems.service

Step 7 :Create `SystemD` Service

```
sudo nano /etc/systemd/system/app_ems.service
```
```
[Unit]
        Description=StudentsystemApplication Java service
        After=syslog.target network.target

        [Service]
        SuccessExitStatus=143
        User=ranjitha
        Type=simple
        Restart=on-failure
        RestartSec=10

        WorkingDirectory=/home/ranjitha/opt/java-backend/
        ExecStart=/usr/bin/java -jar springboot-backend-0.0.1-SNAPSHOT.jar
        ExecStop=/bin/kill -15 $MAINPID

        [Install]
        WantedBy=multi-user.target

```
#### Daemon Reload & systemctl cmd

    sudo systemctl daemon-reload

    sudo systemctl start app_ems.service

    systemctl status app_ems.service
  
![image](https://github.com/user-attachments/assets/03059e86-8ea9-4434-8a8d-50bf04a7bd89)


