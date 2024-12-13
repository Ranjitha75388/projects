# LINUX FUNDAMENTALS - 2

### Process maagement

  - set of instructions computer follow to complete the task..

    - foreground process: process currently running in terminal.can’t use another command until current process complete..

    - background process: process run independently on terminal.also allows terminal to ru other command ..

### Process management commands
    
  - ps: process running for current user.

  - Ps aux:all process running in computer.

  - TOP:how much memory and cpu the certain task is using..

  - top.h :human readable

  - Kill:to terminate the process.

### System monitoring tools:

  - df: display the amount of space used and available in system.
 
  - du:disk usage used to display the space in specific files or dirctory.

  - Free: summary of memory usage.

### Networking commamnds:

  - ping:  test server is connected to the internet.if there is any error there will occur pocket loss.

  - Curl: transfer and download the data.

  - Telent: testing or debuging a issuse..it is not requested because of security purpose.so that we                                                
                      usig ssh.

### SSH

- secure shell that access by a remote system.

- It is used to commuicate between two                              	    computers through intenet with secure.

- The data will be encrypted so that no one can access the data.

- SSH works between client and server.

- The client should be authentication to use the the server.
              
- There are two types of authentication.

    - Keytype authentication
      
    - password type authentication

- The keytype is more secure than passwordtype authentication.the keytype generate keypair as 

    - public key
    
    - private key

- The public key will stored in remote server.The private key will store in user machine.It should not share to anyone.If  only the private key is matched with the public key then we can use the server.
