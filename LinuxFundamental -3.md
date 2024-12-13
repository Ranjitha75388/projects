
# LINUX FUNDAMENTAL 3 
     
  ## Shell Scripting 
       
  - SSH is a programming used in software industries.
  
  - shell scripting is a text file with a list of commands that instruct in operating system to perrform certain task.
  
  - It can be heipful to automate repetive tasks,helping to save time,reduce error.

### Types of shells

  - KSH
    
  - ZSH
    
  - CSH
     
  - BASH

### Advantages

  - Time saving

  - Scheduling task 

  - I/O handling 

### Steps to create script  

- To create a shell script  use text editor vim and save the filename with .sh.
    
    - Vim filename.sh.
    
    - #!/bin/bash at the beginning of the script indicates script should be interpreted using bash shell.
    - Echo command used to print the message to the terminal.
    
          Echo “enter your name”

    - The script file should have executable permission usin the command
        
           chmod +x filename.

    - To execute the commands
           
           ./filename.sh.

    - Read command waits for the user to  input text.
         
          read name

### command explain the purpose of the script.
        
- To add a new file
        
      cat > filename
    
- To get a multiple time
      
      cat >> filename

- To save the file
  
       :wq!
- Exit the file forcefully without saving
      
      :q!
 
### Here are my  some sampels

#### Example -1

```bash
#!/bin/bash
echo"what is your name?"
read name
echo "my name is $name Nice to meet you."
```
#### Output                               
ranjitha@ip-10-0-11-48:~/test$ vim shellscript.sh

ranjitha@ip-10-0-11-48:~/test$ sh shellscript.sh

What is your name?

Ranjitha

My name is Ranjitha Nice to meet you.

#### Example -2
 ```bash
#!/bin/bash
a=20
b=30
if [ $a == $b ]
then
        echo "a is equal to b"
else
        echo "a is not equal to b"
fi
```
#### Output

ranjitha@ip-10-0-11-48:~$ vim shellscript.sh

ranjitha@ip-10-0-11-48:~$ sh shellscript.sh

a is not equal to b

