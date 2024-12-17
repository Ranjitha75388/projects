


# Protocols

### What is Protocol ?
A protocol is a set of rules that defines how data is transmitted and received between devices in a network. It ensures standardized communication, allowing different systems to understand and interact with each other. Examples include TCP/IP, HTTP, and SMTP

###  TCP (Transmission Control Protocol):

- Description: TCP operates at the transport layer of the OSI model. It establishes a connection between two devices before data exchange, ensuring reliable and ordered delivery of information.

- Functionality: It breaks data into packets, assigns sequence numbers, and uses acknowledgment messages to guarantee delivery. It’s connection-oriented, meaning it sets up, maintains, and terminates a connection for data exchange.

### UDP (User Datagram Protocol):

- Description: Also operating at the transport layer, UDP is a connectionless protocol that offers minimal services. It’s like a ‘fire and forget’ approach for data transmission.

- Functionality: It sends data without establishing a connection, providing low latency communication. However, it doesn’t guarantee delivery or order, making it suitable for real-time applications like video streaming or online gaming.

  ![image](https://github.com/user-attachments/assets/9ba6be38-b091-4653-be6f-983849d6eb45)



### IP (Internet Protocol):

- Description: IP functions at the network layer and is a fundamental part of the TCP/IP protocol suite. It handles addressing and routing to ensure data packets reach their intended destinations.

- Functionality: IP assigns unique IP addresses to devices and uses routing tables to direct data across networks. It’s responsible for the logical connection between different devices on the Internet.
- There are two types of IP addresses - IPv4 and IPv6 (v stands for version)

    ### IPv4
 
    - This is a 32 bit IP address, means it contains a combo of 32 (1 and 0's).
    - In this version of IP address there are 4 groups or Octets(8 bits) and each octet is represented by a decimal value in the address. It is easy to remember.

     ### IPv6
    - This IP address contain 128 bits.
    -  We use IPv6 because we have a shortage of IPv4, almost all IPv4 is used now and this is the reason IPv6 is commonly seen nowadays. 
    - This address is represented by a hexadecimal value.

    ### Classes of IP address (mainly for IPv4) :

   ![image](https://github.com/user-attachments/assets/274f71dc-12fe-4c14-86d0-3c1c8dfdac64)




