Linux Assessment-2

1.What is the command to make a Bash script executable? Describe how you would give execution permissions to a script named backup.sh.
```bash
#!bin/bash -bash script
Chmod +x backup.sh
./backup.sh
```
2.What command would you use to count the number of lines in a file called data.txt?

    vim data.txt
    wc -l data.txt
    data.txt

3.How would you extract the current date and time in a Bash script?
  ```
  vim date.sh
  chmod +x date.sh
  ./date.sh
  #!/bin/bash
  current_date_time=$(date +"%d/%m/%Y %H:%M")
  echo "Current date and time: $current_date_time"
```
4.How do you execute a Bash script named script.sh from the terminal?

    Chmod +x script.sh
    ./script.sh

5. What is the purpose of # in a Bash script?

    #is used to add comments

6. How do you print "Hello, World!" to the terminal in a Bash script?
```
#!/bin/bash
 echo "Hello, World!"
```
7.What command is used to read user input in a Bash script?
 ```
 read command
#!/bin/bash
 echo "Enter value of a"    read a
 echo "Value of a is, $a!"
```
8.How do you assign the value 10 to a variable named count in a Bash script?

      count=10

9.What does the command chmod 755 script.sh do to the permissions of script.sh?

    Script.sh file allow specific access for owner,group and others
    7(owner)-rwx  5(group)-rx 5(others)-rx =>rwx-rx-rx

10.What does the command chmod 644 file.txt accomplish?
   
     6(owner)- rw  4(group)-r  4(others)-r =>rw-r—r—

11.What does the command chmod u+x,g-w script.sh do?

    u+x: It will adds execute permission for the user (owner)
    g-w: It will removes write permission for the group

12.How can you remove execute permissions from a script named script.sh for all users?
    
     chmod +x script.sh

13.How can you change the permissions of all scripts in the current directory to be executable by the user and group but not by others?

    chmod ug+x,o-x  filename.sh

14.How would you check if a file exists using an if statement in Bash?
```
  if [ -e "filename" ]; then
    echo "File exists."
else
    echo "File does not exist."
fi
```
15. If a user tries to execute a script but receives a "Permission denied" error, what steps would you take to troubleshoot this? 
```
Ls-l script.sh
chmod +x script.sh
./script.sh
Ensure that the script has a valid shebang (#!/bin/bash) at the top
```

16.Write a Bash script that accepts two arguments (file and directory) and checks if the given file exists. If it does, move it to the provided directory.
```
file=$1
directory=$2
if [ -e "$file" ]; then
       mv “$file” “$directory”
       echo “file is moved to directory”
else
echo “ file does not exist”
fi
```
17. How can you append output to a file instead of overwriting it?
 ```
 cat >> file.txt
```
18. How do you create a directory named myfolder in a Bash script, ensuring that it doesn't throw an error if the directory already exists?
```
      #!/bin/bash
            mkdir -p myfolder
```
19.Write a Bash command that checks if a directory exists, and if not, creates it.
```
If [-d myfolder] ;then
Echo “directory is exists”
Else
mkdir myfolder
echo "directory is created"
fi
```
20.How would you check if a variable named x is equal to 5 in a Bash script?
```
x=5
if [ "$x" -eq 5 ]; then
    echo "x is equal to 5"
else
    echo "x is not equal to 5"
fi
```
21.Create a script that accepts a list of filenames as arguments and checks if each file exists. If a file does not exist, it should create an empty file with that name.
```
for filename in "$@"; do
if [ -e "$filename" ]; then
echo "File '$filename' already exists."
 else
touch "$filename"
echo "File '$filename' has been created."
fi
done
```
22.Write a shell script that takes a directory as input and performs the following operations:
```
     Lists all files and directories in the given directory.
echo "Listing all files and directories in '$directory': ls -l "$directory"
     Counts and displays the number of files and directories separately.
number_files=$(find "$directory" -maxdepth 1 -type f | wc -l)
number_directories=$(find "$directory" -maxdepth 1 -type d | wc -l)
```
23.Write a shell script that creates a new file named example.txt in the current directory, write the text "Hello, World!" to the file, and saves it.
```
Vim example.txt
#!/bin/bash
echo  “Hello,World!”
chmod +x example.txt
./example.txt
```
24.Write a shell script that copies the example.txt file to a new file named example_backup.txt and then renames example.txt to example_old.txt.
```
#!/bin/bash
cp "$example.txt" "$example_backup.txt"
echo “copy file to new file”
mv "$example.txt" "$example_old.txt"
echo "Rename file to old file
```
25.Write a shell script that reads a date in the format YYYY-MM-DD from user input and converts it to the format DD/MM/YYYY.     
```
read -p date
$(date '+%Y-%m-%d')
$(date ‘+%d/%m/%Y’)
```
26.Write a shell script that prompts the user to enter a filename, then displays the content of that file if it exists.
```
read -p "Enter the filename: " filename
if [ -e $filename ]; then
echo "Contents of $filename:"
cat "$filename"
 else
echo "File '$filename' does not exist."
fi
```
27.Write a Bash script that automates the process of backing up a directory to a specified location. The script should create a timestamped archive file.
```
source_directory=$1
 backup_directory=$2
mkdir -p "$backup_directory"
timestamp=$(date +"%Y%m%d_%H%M%S")
archive_name="$(basename "$source_directory")_$timestamp.tar.gz" tar -czf "$backup_directory/$archive_name" -C "$source_directory"  
```
28.Write a script that automates the cleanup of temporary files in a specified directory. The script should remove files older than a specified number of days.
```
find "$directory" -type f -mtime +"$days" -exec rm -f {} \;
echo "Cleanup completed: Removed files older than $days days from '$directory'."
```
29.Create a Bash script that accepts a username and a password as arguments. The script should create a new user with the provided username and set the password to the provided value.
```
username=$1
password=$2
sudo useradd "$username"
echo "$username:$password" | sudo chpasswd
```
30.Write a Bash script that reads a list of usernames from a file and creates user accounts on a Linux system for each username. Use a simple default password for all the new users.
```
usernames_file=$1
default_password="Password123"
while IFS= read -r username; do
    if [[ -n "$username" ]]; then
        sudo useradd "$username"
        echo "$username:$default_password" | sudo chpasswd
    fi
done < "$usernames_file"
```
31.Write a Bash script that lists all currently running processes and filters the output to display only processes belonging to a specific user. The username should be provided as an argument to the script.
```
username=$1
echo "Currently running processes for user '$username':"
 ps -u "$username"
```
32.Write a Bash script that uses the top command to display the top 5 memory-consuming processes on the system and saves the output to a file named top_processes.txt.
```
output_file="top_processes.txt"
top -b -n 1 | awk 'NR==7,NR==11' > "$output_file"
```
33.Create a Bash script that lists all the files in the /home/ubuntu directory and displays their sizes, sorting the output by size in descending order.
```
directory="/home/ubuntu"
ls -lhS "$directory" | awk 'NR>1 {print $9 ": " $5}'
```
34.Create a script that outputs the total number of processes currently running on the system, along with the total number of users logged in.
```
total_processes=$(ps aux | wc -l)
total_users=$(who | wc -l)
echo "Total number of processes currently running: $total_processes"
echo "Total number of users currently logged in: $total_users"
```
