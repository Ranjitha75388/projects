                                                               Linux Assessment-1
1. Which command is used to move a file from one directory to another? 

      mv

2. How do you change the permissions of a file to be readable, writable, and executable by the owner only? 

      chmod

3.What command would you use to rename a directory called oldfolder to newfolder? 
  
      mv oldfolder newfolder

4.What is the command to display all active processes running on your system? 

      ps

5.What is the command to check the available free memory on your system? 
  
      free

6.What command would you use to delete a directory named myfolder along with all its contents, including files and subdirectories? 

      rmdir myfolder

7.What is the command to find the size of all files and directories, sorted in descending order? 

      ls -s

8.How would you recursively change the ownership of all files in a directory, but only for files and not for subdirectories?

      chmod -R

9.Which command would you use to display disk space usage in human-readable format, but only for a specific directory and its subdirectories? 
  
      du -h

10.Use the ping command to check the connectivity to google.com. What result indicates that the server is reachable? 

      ping google.com

11.How do you check the size of all files in a directory that are larger than 50MB?

      du

12.What command would you use to find and delete files older than 1 day in a specific directory?

      find and kill

13.What is the difference between df and du commands? When should you use each?       

      df- display the amount of disk space used and available in sysytem.  
      du-display the space in specific file or directory

14.What is the difference between using symbolic mode (chmod u+x) and numeric mode (chmod 755) with the chmod command, and when would you prefer one over the other?                      chmod(u+x)gives permission to user to execute a file...  

      (chmod755) user had full permision,group and others had read and execute permission.

15.You want to make a script executable by the owner and readable by the group, but no permission15s for others. Which chmod command would you use, and how do you interpret the permission setting?

      chmod 140

16.How would you list the top 2 processes consuming the most memory on a Linux system? 

      top

17.A user accidentally changes the permissions on an entire directory structure, making it inaccessible to the root user (chmod 000 /user/directory). How can you regain access to the directory and its contents? 

      sudo chmod 777

18.You are tasked with setting up a shared directory for a group of developers, but you need to ensure that any files they create in the directory are owned by the group, not the individual user. What combination of commands and configurations would you use to achieve this?

19.A server is experiencing high load, and some processes seem to be consuming excessive memory. You’ve been tasked to identify the specific processes causing the issue and terminate them. How would you approach this task using available Linux commands? 

       ps aux,kill

20.Explain how SSH (Secure Shell) works and describe the difference between password-based authentication and key-based authentication. Which method is more secure, and why? 
(Presentation for 1 to 2 mins).

       SSH is a network protocol that communicates between two computers through internet.password based authentication has user name and password,in key based authentication it generate private key and public key..keytype authentication is better than password type because of security purpose.

21.How do you SSH into the remote machine? Describe the command you would use. 

       ssh username@ip address.
