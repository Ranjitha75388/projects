
#  Prerequisites Installation (phase-0)
 ### Following toolset to be installed as the first step (Ubuntu based)
* Java 17 
* Maven 3.8.8
* NodeJs 14.x
* MySQL 8.x

 ### Step1 : Java

```bash
            sudo apt update
            sudo apt install openjdk-17-jdk openjdk-17-jre
```
 ### Step2 : Maven 
 
``` bash 
            wget https://dlcdn.apache.org/maven/maven-3/3.8.8/binaries/apache-maven-3.8.8-bin.tar.gz
            tar -xvf apache-maven-3.8.8-bin.tar.gz
            mv apache-maven-3.8.8 /opt/ 
```
* ###  Maven M2_HOME Setup
   
    * Open vim ~/.profile and add the following and save the file.

        ```bash
            M2_HOME='/opt/apache-maven-3.8.8'
            PATH="$M2_HOME/bin:$PATH"
            export PATH
        ```
    * ### Install maven

        ```bash
            sudo apt install mvn
        ```

    - #### Verify the version of maven, it should be 3.8.8
        ```bash
            mvn -version 
        ```    
### Step3: NodeJs

```bash
            sudo apt update
            curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -
            sudo apt -y install nodejs && npm
            node  -v && npm -v
```
### Step4:MySQL

* #### Install MySQL Server

    ```bash
            sudo apt update
            sudo apt install mysql-server
    ``` 
- ### Update `root` user password
   
    *  Log in to MySQL as the root user.
        ```bash
             sudo mysql     
        ``` 
    *  Recevie "mysql>"prompt
         ```bash
            ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
        ```
    -   Replaced password as 'ranjitha'
        ``` bash 
            exit
        ```
- ### Configure User
    - Enter Root password 'ranjitha' and Login 
        ```
            sudo mysql -u root -p
        ```
    - Create new user and password as username=’ranjitha’;password=’ranjitha’
        ```
            CREATE USER 'username'@'%' IDENTIFIED WITH mysql_native_password BY 'password'
        ```
    - Granting privileges enables users to perform actions such as SELECT, INSERT, UPDATE, DELETE, and more on specified database objects.) to other users.
        ```
            GRANT ALL PRIVILEGES ON *.* TO 'username'@'%' WITH GRANT OPTION; 
        ```
        ``` 
            FLUSH PRIVILEGES;
        ```
        ```
            exit
        ```
- ### Create Database

    - Log into MySQL as a specific user (replace username ‘ranjitha’ ,password 'ranjitha')
        ```
            sudo mysql -u username -p
        ```
    - Once logged into the MySQL shell, you can create a new database named as 'mynewdatabase'
        ```
            CREATE DATABASE (mynewdatabase);
        ```
    - To confirm that the database was created successfully, list all databases.
        ```
            SHOW DATABASES;
        ```
       
 - ### Check details inside my databases

```
        mysql -u ranjitha -p
        SHOW DATABASES;
        USE
        SHOW FULL TABLES;
        SELECT * FROM
```
            



