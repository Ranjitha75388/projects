

# Shell scripting Assessment
    
1. What is the command to make a Bash script executable? Describe how you would give execution permissions to a script named backup.sh. 
``` 
To execute :./backup.sh
To execute permission : chmod +x backup.sh
```

2. What command would you use to count the number of lines in a file called data.txt? 
```
Count size  :wc-l data.txt
```  
3. How would you extract the current date and time in a Bash script? 
```
current_date_time=$(date)
echo $current_date_time
```
4. How do you execute a Bash script named script.sh from the terminal?
```
Execute bashscript : sh script.sh 
```
5. What is the purpose of # in a Bash script? 

- The purpose of # in a Bash script is to denote comments.
- Anything following # on that line will be ignored by the interpreter, allowing you to add notes or explanations within your code  

6. How do you print "Hello, World!" to the terminal in a Bash script?

       echo” Hello ,world” 

7. What command is used to read user input in a Bash script? 

       read -p "Enter your input: " userInput

8. How do you assign the value 10 to a variable named count in a Bash script? 

       count=10
    
9. What does the command chmod 755 script.sh do to the permissions of script.sh? 
 
- The owner has read (r), write (w), and execute (x) permissions (7).
- The group has read (r) and execute (x) permissions (5).
- Others have read (r) and execute (x) permissions (5) 
 
10. What does the command chmod 644 file.txt accomplish?
   
- The owner has read (r) and write (w) permissions (6).
- The group has read (r) permission (4).
- Others have read (r) permission (4)

11. What does the command chmod u+x,g-w script.sh do? 

The command chmod u+x,g-w script.sh modifies permissions on script.sh by adding execute permission for the user (u) while 
removing write permission for the group(g) 
            
12. How can you remove execute permissions from a script named script.sh for all users? 
```
Chmod -x script.sh
```
    
13. How can you change the permissions of all scripts in the current directory to be executable by the user and group but not by others?
    
- Execute permission for user and group=  Chmod ug+x
- Not execute permission for others =chmod o-x
    
14. How would you check if a file exists using an if statement in Bash? 

```
if [ -e filename ]; then
echo "File exists."
fi
```              
               
15. If a user tries to execute a script but receives a "Permission denied" error, what steps would you take to troubleshoot this?

-  If they have execute permissions on the script using ls -l.
- If they are trying to run it from an appropriate directory.
- If they have sufficient permissions on any parent directories
 
16. Write a Bash script that accepts two arguments (file and directory) and checks if the given file exists. If it does, move it to the provided directory.

```
#!/bin/bash
if [ -e "$1" ]; then
mv "$1" "$2"
echo "Moved $1 to $2"
else
echo "$1 does not exist."
fi
```                             

17. How can you append output to a file instead of overwriting it? 

        echo "New content" >> filename.txt

    
18. How do you create a directory named myfolder in a Bash script, ensuring that it doesn't throw an error if the directory already exists? 

        mkdir -p myfolder

19. Write a Bash command that checks if a directory exists, and if not, creates it. 

```
[ ! -d "directory_name" ] && mkdir "directory_name"

```
20. How would you check if a variable named x is equal to 5 in a Bash script?

```
if [ "$x" -eq 5 ]; then
echo "x is equal to 5"
fi
```

21. Create a script that accepts a list of filenames as arguments and checks if each file exists. If a file does not exist, it should create an empty file with that name. 
```
#!/bin/bash
for filename in "$@"; do
if [ ! -e "$filename" ]; then
touch "$filename"
echo "$filename created."
else
echo "$filename exists."
fi
done
```
   
22. Write a shell script that takes a directory as input and performs the following operations: 
 
• Lists all files and directories in the given directory.
        
    Mkdir example
    cd example
    touch script.txt
    ls-l example   
                            
• Counts and displays the number of files and directories separately.

    ls | wc-l example
                               
   
23. Write a shell script that creates a new file named example.txt in the current directory, write the text "Hello, World!" to the file, and saves it. 
```
Mkdir example
cd example
pwd
touch example.txt
vim example.txt
echo “hello world”
:wq!
chmod +x example.txt
./example.txt
```                       

24. Write a shell script that copies the example.txt file to a new file named example_backup.txt and then renames example.txt to example_old.txt. 

- Cp example.txt backup.txt
- mv example.txt example old.txt 

25. Write a shell script that reads a date in the format YYYY-MM-DD from user input and converts it to the format DD/MM/YYYY. 

```
#!/bin/bash 
read -p "Enter date (YYYY-MM-DD): " date 
formatted_date=$(echo $date | awk -F '-' '{print $3 "/" $2 "/" $1}') 
echo $formatted_date 
```

26. Write a shell script that prompts the user to enter a filename, then displays the content of that file if it exists. 

```
#!/bin/bash 
read -p "Enter filename: " filename 
if [ -e "$filename" ]; then 
cat "$filename" 
else 
echo "$filename does not exist." 
fi 
```

27. Write a Bash script that automates the process of backing up a directory to a specified location. The script should create a timestamped archive file.
```
#!/bin/bash 
tar -czvf backup_$(date +%Y%m%d_%H%M%S).tar.gz /path/to/directory
```

28. Write a script that automates the cleanup of temporary files in a specified directory. The script should remove files older than a specified number of days. 
```
#!/bin/bash 
find /path/to/temp/files -type f -mtime +N -exec rm {} \; 
```

29. Create a Bash script that accepts a username and a password as arguments. The script should create a new user with the provided username and set the password to the provided value.
```
USERNAME=$1
PASSWORD=$2
sudo user_add  -m”$USERNAME”
sudo chpasswd”$PASSWORD” 
```

30. Write a Bash script that reads a list of usernames from a file and creates user accounts on a Linux system for each username. Use a simple default password for all the new users. 
```
#!/bin/bash 
while IFS= read -r username; do 
sudo useradd $username 
echo "$username:default_password" | sudo chpasswd 
done < usernames.txt 
```

31. Write a Bash script that lists all currently running processes and filters the output to display only processes belonging to a specific user. The username should be provided as an argument to the script.

```
USERNAME=$1
ps-u “$USERNAME”
```
32. Write a Bash script that uses the top command to display the top 5 memory-consuming processes on the system and saves the output to a file named top_processes.txt.

```    
Vim processes.txt
#!/bin/bash  
top -b -n 1 | head -n 12 | tail -n 5 > top_processes.txt  
:wq!
```
33. Create a Bash script that lists all the files in the /home/ubuntu directory and displays their sizes, sorting the output by size in descending order.
     
``` 
ls /home/ubuntu directory
du-h ”ubuntu directory”/* | sort-hr   
```

34. Create a script that outputs the total number of processes currently running on the system, along with the total number of users logged in. 
```        
total _processes=$(ps aux|wc -1) 
total_users=$( who | wc-l)
```


