# Linux fundamentals training 1

## INTRODUCTION OF DEVOPS

  ### What is Data center?

  - It is a physical resource.
   
  - Maintanance high
   
  - required experienced developers to operate. etc...

 ### What is cloud?
  - Virtual resource
  
  - maintance low
  
  - easy to operate .etc..

### data center and cloud
         
  - In data center it takes some weeks to rent resourse ,but in cloud we can rent it immediately , as well as to terminate  etc..
                
## BASIC LINUX COMMANDS

- ls          - lists   

- cd          -change directory
  
- pwd      -present working directory
  
- chmod  -chage modification
  
- chown   -change owner
 


#### I have tried some commands in ubuntu terminal and here is the logs,

logi@Timesyslaptop:~$ mkdir ranjitha-training

logi@Timesyslaptop:~$ cd ranjitha-training/

logi@Timesyslaptop:~/ranjitha-training$ touch file1.txt 

logi@Timesyslaptop:~/ranjitha-training$ ls
file1.txt

logi@Timesyslaptop:~/ranjitha-training$ pwd
/home/logi/ranjitha-training  

logi@Timesyslaptop:~/ranjitha-training$ free
               total        used        free      shared  buff/cache   available
Mem:         7982628     1971796     3706996      325812     2916268     6010832
Swap:       14524412           0    14524

logi@Timesyslaptop:~/ranjitha-training$ df
Filesystem     1K-blocks      Used Available Use% Mounted on
tmpfs             798264      2240    796024   1% /run
/dev/sda2      191135628  11401816 169951796   7% /
tmpfs            3991312         0   3991312   0% /dev/shm
tmpfs               5120         8      5112   1% /run/lock
efivarfs             192        61       127  33% /sys/firmware/efi/efivars
tmpfs            3991312         0   3991312   0% /run/qemu
/dev/sda5       13349164    193644  12455616   2% /boot
/dev/sda3      585328096 538548728  17019728  97% /home
/dev/sda6        1098628      6284   1092344   1% /boot/efi
tmpfs             798260       128    798132   1% /run/user/1000


