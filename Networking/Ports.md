

# Network Ports

- Network ports are virtual endpoints that bridge data transmission among multiple applications, services, or devices within a network. It is a logical connection that is established between multiple devices to transfer and exchange data among them. These ports ensures the smooth flow of information and make sure that data reaches its destined address.

- In a practical sense, when we interact with various online services like browsing, streaming, or downloading, network ports are working in the background. It manages the data traffic and ensures to make every process works independently and efficiently.

- Each network port will have a unique number that differentiates it from others. This unique number is known as the port number.

## Categories of Ports
- Port numbers range from 0 - 65535 and these are assigned by an organization called IANA (Internet Assigned Numbers Authority). 
- These 65,535 port numbers are broken down into the following three categories:-

  ### 1. System Ports
  Port numbers from 0 - 1023 are called systems or well-known ports. These are common ports that most people use every day. Some of them are:

  - 80(HTTP)
  - 443(HTTPS)
  - 25(SMTP)
  - 21(FTP)

  ### 2. Registered Ports
  Port numbers from 1024 - 49151 are called user or registered ports. These are ports that can be registered and accessed by companies and developers for any particular service. Some of them are:

  - 1102(Adobe Server)
  - 1433(Microsoft SQL Server)
  - 1416(Novell)
  - 1527(Oracle)

  ### 3. Dynamic Ports
  Port numbers from 49152 - 65535 are called dynamic or private ports. These are client-side ports that are free to use. Computers generally use it for local addresses temporarily during a session with the server, for example when viewing a web page.

Out of these three categories, the well-known and registered port numbers are used on a server.So whenever our computer wants to use a service on another server, it assigns itself one of these port numbers.

### Some Popular Port Numbers
Some common/Popular port numbers that are used by those applications/services which are frequently used by us-

### PortNumber	 Used By
  - 80	- HTTP(Hyper Text Transfer Protocol)
  - 23	- Telnet
  - 25	- SMTP(Simple Mail Transfer Protocol)
  - 53	- DNS(Domain Name System)
  - 7    -	Echo
  - 20/21	- FTP(File Transfer Protocol)
  - 69	 - TFTP(Trivial File Transfer Protocol)
  - 443	 - HTTPS(Hyper Text Transfer Protocol Secure)
  - 22	- SSH(Secure Shell)
  - 110	 - POP3(Post Office Protocol version 3)
  - 67/68	 - DHCP(Dynamic Host Configuration Protocol0
  - 123	 - NTP(Network Time Protocol)
  - 143	 - IMAP(Internet Messaging Access Protocol)
  - 1433	 - Microsoft SQL
  - 3306	- MySQL
  - 5432	- PostgreSQL
  - 27017- 	MongoDB

### Functioning Of Ports
- A port always functions along with an IP address.
- An IP address is a numeric address that acts as an identifier for a computer or a device on a network. For communication purposes, each device needs to have an IP address. 
- An IP address and a port number work in sync to exchange data on a network.

#### Example

- Port 80 is associated with HTTP which are web pages so whenever we visit a web page from our computer, we're using port 80.

  ![image](https://github.com/user-attachments/assets/ea7a3171-7ace-4bdd-9dde-c2a8239903b5)


- Let's say we want to visit Google's web page so we will open up a web browser and type google.com in the address bar but before it pops up on our screen, there are some intermediary steps behind the scenes.
-  First of all, it needs to convert the domain name of google.com into Google's IP address (215.114.85.17), and in addition, add port number 80 to the IP address since we are using a web browser that is using HTTP, to complete the foreign address(address of the server - 215.114.85.117:80). This foreign address is going to be used to locate Google's web server.
- Once we locate the server, the IP address part of the foreign address loses its significance and the port will come into play. Now Google's web server will see the incoming request with port number 80 and will forward that request to its built-in web service and you will eventually retrieve Google's web page.

