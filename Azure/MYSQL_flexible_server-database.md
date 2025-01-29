![Screenshot from 2025-01-29 13-09-00](https://github.com/user-attachments/assets/2ab14d77-7d95-4677-8f65-070d2d78651f)
![image](https://github.com/user-attachments/assets/31fe3dec-ff19-4a50-922e-07b54a9e072f)
![image](https://github.com/user-attachments/assets/36d29e28-4f15-48fa-aaa2-3133eb7372b2)


manuall insert data in vm
Step1: Before inserting data, confirm the column names and data types:
```
DESC employees;
```

![image](https://github.com/user-attachments/assets/ee25686c-d9c9-4376-84a2-da47520413dd)

Step2 : Insert Data Manually
```
INSERT INTO employees (name, age, department, salary)
VALUES ('John Doe', 30, 'IT', 60000.00);
```
Step3:After inserting, check the table again for verification
```
SELECT * FROM employees;
```
![image](https://github.com/user-attachments/assets/50a834b9-1637-49a7-b7fe-dbba863b2e81)

Export command
```
sudo mysqldump -u root -p mynewdatabase(db-name) > mynewdatabase.sql(newfilename)
```
![image](https://github.com/user-attachments/assets/ebe41635-e9e0-4930-8321-5b620f1fc8ca)


creating new databse in flexible server
![image](https://github.com/user-attachments/assets/fc56ba5e-948c-4f18-80cd-c7d6fa2fddfb)

importing(copying) from database vm to flexible server db
```
mysql -h mysql-db-demo.mysql.database.azure.com(server-name) -u ranjitha(admin-name) -p new_flexible_db(database-name in flexible-server) < mynewdatabase.sql(dumpfile)
```
mysql-db-demo.mysql.database.azure.com(server-name)
ranjitha(admin-name)
new_flexible_db(database-name in flexible-server)
mynewdatabase.sql(dumpfile created during export)


