
# INSTALLATION OF NGINX

Step 1: Update the package index
``` 
  sudo apt update
```

step 2: Installing nginx
```  
  sudo apt install nginx
```

step 3: Adjusting firewall
```
  sudo ufw app list
```

step4 : Enable nginx HTTP
```
  sudo ufw allow ‘Nginx HTTP’
```

step 5: Verify the changes
```
  sudo ufw status
```

step6 : Checking the status
``` 
  systemctl status nginx
```

step7 : Confirm the software is running properly
```
  hostname -I
  127.0.1.1
```

step8 : Start nginx
```
  sudo systemctl start nginx
```

step9 : Enable nginx to start on boot
```
  sudo systemctl enable nginx
```

step10 : To stop the webserver
```
  sudo systemctl stop nginx
```
step11 : To restart the webserver
```
  sudo systemctl restart nginx        
```











