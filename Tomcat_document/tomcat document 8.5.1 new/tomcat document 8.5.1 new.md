`	`**INSTALLATION OF  TOMCAT**


**Step 1 : Update the package index**

`	    `sudo apt update 

**Step 2 : Install Openjdk (Java)**

`	      `sudo apt install default-jdk

**Step 3 : Create a Tomcat user**

`	     `sudo useradd -m -U -d /opt/tomcat -s /bin/false tomcat

**Step 4 : Install Tomcat on Ubuntu 24.04 LTS**

`	     `sudo wget [https://www-eu.apache.org/dist/tomcat/tomcat-8/v8.5.1/bin/apache-](https://www-eu.apache.org/dist/tomcat/tomcat-11/v11.0.0/bin/apache-)	    

`	     `tomcat-8.5.1.tar.gz -P /tmp

**Step 5 : Extract it to the /opt/tomcat directory**

`	     `sudo tar xzvf apache-tomcat-8.5.1.tar.gz -C /opt/tomcat –strip-components=1

**Step 6 : Update Permissions of Tomcat**

`	      `sudo chown -R tomcat:tomcat /opt/tomcat

**Step 7 : Configure Tomcat as a Service**

`	      `cd /etc/systemd/system

**Step 8 : Create a tomcat.service file using nano command**

`	      `sudo nano tomcat.service

**Step 9 : Add the following content into it**

`	   	  `[Unit]

`                  	 `Description=Apache Tomcat Web Application Container

`                    `After=network.target

`                    `[Service]

`                    `Type=forking

`                  	 `User=tomcat

`                  	 `Group=tomcat

`                  	 `Environment="JAVA\_HOME=/usr/lib/jvm/java-11-openjdk-amd64"

`                  	 `Environment="CATALINA\_HOME=/opt/tomcat"

`                  	 `Environment="CATALINA\_BASE=/opt/tomcat"

`                    `Environment="CATALINA\_PID=/opt/tomcat/temp/tomcat.pid"

`                    `ExecStart=/opt/tomcat/bin/startup.sh

`                     `ExecStop=/opt/tomcat/bin/shutdown.sh

`                     `[Install]

`                     `WantedBy=multi-user.target


**Step 10 : Reload systemd and Start Tomcat**

`	       `sudo systemctl daemon-reload

**Step 11 : Start the Tomcat service**

`	       `sudo systemctl start tomcat

**Step 12 : Enable Tomcat to start on boot**

`	        `sudo systemctl enable tomcat

**step 13 : Start with below link for tomcat**

`	      `http://127.0.1.1:8080/


![](Aspose.Words.308a8476-52f8-4f77-a2eb-dea7dda950c1.001.png)


