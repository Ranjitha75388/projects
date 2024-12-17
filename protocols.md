


# Protocols

### What is Protocol ?
A network protocol is a set of rules which is set up by peoples that determine how a particular data is transmitted between different devices in the same network. e.g:- HTTP, TCP, IP, FTP, SMTP etc.
 
### HTTP (Hypertext Transfer Protocol)
- Functionality:It operates in application layer.It is a client server stateless (means it never stores any data of client)protocol, and it tells us how it request any data from the server and also tells us how the server will send the data back to the client.
- Request/Response Cycle:
  - HTTP Request: Initiated by the client to fetch data.
  - HTTP Response: Sent by the server containing the requested data.
- Common HTTP Methods:
   - GET: Retrieve data from the server.
  - POST: Send data to the server.
   - PUT: Update existing data on the server.
  - DELETE: Remove data from the server.
- Status Codes:
  - 1XX: Informational
  - 2XX: Success (e.g., 200 OK)
  - 3XX: Redirection (e.g., 301 Moved Permanently)
  - 4XX: Client Error (e.g., 404 Not Found)
  - 5XX: Server Error (e.g., 500 Internal Server Error)
### SMTP/POP (Simple Mail Transfer Protocol and Post Office Protocol)
- It operates in application layer.
- SMTP is used in sending and receiving any email from senders SMTP server to Receiver's SMTP server
- POP is used to download any email from POP server
### FTP (File Transfer Protocol)
- It operates in application layer.
- FTP is used to download, upload and transfer files from one host to another host.

### TCP (Transmission Control Protocol)
- It operates in transport layer.
- In this protocol, if any segments of data is transmitting from Host A to Host B, the destination (Host B) will send back a receipt/acknowledgement to sender (Host A).
- Means whenever we send data with TCP, it actually takes care of acknowledgement.
- So this protocol is reliable, and also it retransmits the data segment if any segment is dropped.
- In network language, this protocol is connection oriented because it believes in making connection end to end. It takes 20 bytes to add TCP information on each segment.
- This information contains port numbers. Port number is in which application you want to send your data is recognized by port numbers. e.g. :- HTTP - port 80, MongoDB - port 27017, SQL - port 1433 etc.
### UDP (User Datagram Protocol)
- It operates in transport layer.
- This protocol is connectionless, means it does not make any connection with receiver to check whether all data segments are reached successfully to the receiver or not.
- So it is not reliable since it does not take care of any acknowledgement.
- Retransmission is not possible with this protocol.
- It takes 8 bytes to add UDP information on each segment. These 8 bytes contain port number, same like TCP.

  ![image](https://github.com/user-attachments/assets/3e8cb1e6-2e92-43f6-bf07-b70dbba0288e)



### IP Address and its Types and Classes
- Every device on the internet must have at least one unique network address identifier known as the IP (Internet Protocol) address. 
- This address is essential for routing packets of information through the network. Without our address none can find our location and like that without an IP address a device can't be found on a network.
- There are two types of IP addresses - IPv4 and IPv6 (v stands for version)

    ### IPv4
 
    - This is a 32 bit IP address, means it contains a combo of 32 (1 and 0's).
    - In this version of IP address there are 4 groups or Octets(8 bits) and each octet is represented by a decimal value in the address. It is easy to remember.

    ### IPv6
    - This IP address contain 128 bits.
    -  We use IPv6 because we have a shortage of IPv4, almost all IPv4 is used now and this is the reason IPv6 is commonly seen nowadays. 
    - This address is represented by a hexadecimal value.


   ![image](https://github.com/user-attachments/assets/4590ee1c-d0f2-422e-8b3e-29b2eaf0b742)

    ### Classes of IP address (mainly for IPv4) :
 
     ![image](https://github.com/user-attachments/assets/4ae0c9d5-9f11-41a5-a094-1a1c81d90bf0)

    ![image](https://github.com/user-attachments/assets/e296fd2b-6f9e-4bea-85d5-e1c34daf4366)

Example:
-  There are two parts to an IP address - Network ID and Host ID (Any device which gets the IP address is called a Host).
-  To connect device A with device B we have to check just the network ID only for both the devices. Suppose device A (17.0.0.1) and device B (17.0.4.2), so both are class A IP address because their first octet under the range 0-126. For class A the network ID is first octet and remaining three octets for Host ID and for class B the first two octets are network ID and remaining Host ID and for class C the first three octets are network ID and the last octet is Host ID. So here the net ID of both the device is 17, so they can connect with each other easily and both devices are in a same network. But If the network ID is different, then we have to use a Router to connect them because a Router is used to connect two or more different networks.


 
 
 
 
 
 
 
 
