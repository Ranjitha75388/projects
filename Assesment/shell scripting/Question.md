# Shell Script assessment

1. Print the count from 1 to 10 ==> use loops

   #### expected output:
 
   count 1
 
   count 2
   .
   .
   .
   
   count 10

===========================================================

2. Request keyboard input for email address and save it in a file, it should be in loop and allow us to enter multiple email address. There should 2 choices , 1. Add email address and 2.Exit script . When choosing the option, it should add the email address to a file and again the choices should be displayed, now again if the choice of 1 is choosen then the second email address should be append to the same file. the choice list should be again repeating, if choice is 2 then the script should exit ==> use conditional statement 

 #### expected output:
 
 [1] Add email address
 
 [2] Exit script 

 Please choose : 1
 
 Add email address : rpprabhu19@outlook.com 
 
 [1] Add email address
 
 [2] Exit script 
 
 Please choose : 1
 
 Add email address : vigneshs00@outlook.com 
 
 [1] Add email address
 
 [2] Exit script 
 
 Please choose : 2

==============================================================

3. Read the file created in the previous task and send email to each one to Welcome them to DevOps training

 #### expected output:
 
recipient="rpprabhu19@outlook.com"  ==>> email should be sent to all the email address captured in the previous task

subject="Linux Training - Schedules"

message="Dear Sir/Madan, Welcome to Jumisa Training Program. Our classes on DevOps starts on 1 Sep 2021"
 
==============================================================

4. Get the date and time, display it readable format. ==> use date command and parse it

 #### expected output:
 
 Current Date is: 01-SEP-2021
 Current Time is: 10:20:45 AM or PM
