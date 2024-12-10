
# Daemonize the services(phase-2)

This phase guides how to daemonize the services

Follow phase-1 (https://github.com/Ranjitha75388/Jumisa-Technology/blob/main/3-Tier%20web%20Application/Build%20and%20deploy%20application(phase-1).md)

## 1. Java Backend

Step1: cd /opt

Step2: create folder in /opt dir ‘java-backend’

Step3: cd /opt/java-backend

Step4: Copy the `*.jar` generated in `Phase 1` using `mvn clean install` to `/opt/java-backend`
```
      cp -r /home/logi/Downloads/ems-ops-phase-0/springboot-backend/target/springboot-backend-0.0.1-SNAPSHOT.jar .
```

### Step5: Create `SystemD` Service
```
    sudo nano /etc/systemd/system/app_ems.service
```
- Use the following.Replace 'user=logi' with OS username.
```
    [Unit]
        Description=StudentsystemApplication Java service
        After=syslog.target network.target
        
    [Service]
        SuccessExitStatus=143
        User=logi
        Type=simple
        Restart=on-failure
        RestartSec=10
        
        WorkingDirectory=/opt/java-backend/
        ExecStart=/usr/bin/java -jar springboot-backend-0.0.1-SNAPSHOT.jar
        ExecStop=/bin/kill -15 $MAINPID
        
    [Install]
        WantedBy=multi-user.target
```
- ### Step6 : Daemon Reload & systemctl cmd
```
      sudo systemctl daemon-reload
      sudo systemctl start app_ems.service
      systemctl status app_ems.service
```

## 2. React Frontend

Step1: cd /opt

Step2: create folder ‘react-frontend’

Step3: cd /opt/react-frontend

Step4: Copy the `build` folder generated phase-1 using `npm run build` to `/opt/react-frontend`
```
      cp -r /home/logi/Downloads/ems-ops-phase-0/react-hooks-frontend/build .
```

Step5: Install `serve` node package
```
      npm install -g serve
```
Step6: Create `SystemD` Service
```   
      sudo nano /etc/systemd/system/reactapp_ems.service
```
- use the following.Replace 'User=logi' with OS userame.
```
    [Unit]
        Description=StudentsystemApplication React service
        After=syslog.target network.target
        
    [Service]
        SuccessExitStatus=143
        User=logi
        Type=simple
        Restart=on-failure
        RestartSec=10
        
        WorkingDirectory=/opt/react-backend/
        ExecStart=serve -s build
        ExecStop=/bin/kill -15 $MAINPID
        
    [Install]
        WantedBy=multi-user.target
```
Step7: Daemon Reload & systemctl cmd
```
      sudo systemctl daemon-reload
      sudo systemctl start reactapp_ems.service
      systemctl status reactapp_ems.service
```
