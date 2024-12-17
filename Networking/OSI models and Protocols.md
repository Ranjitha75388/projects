
# OSI models and Protocols
There are mainly two types of network model 
- OSI Reference Model
- TCP/IP Model
## OSI Reference Model:
- The OSI (Open Systems Interconnection) Model is a set of rules that explains how different computer systems communicate over a network. 
- The OSI Model consists of 7 layers and each layer has specific functions and responsibilities.
- Using this model, troubleshooting has become easier as the error can be detected at different levels
- This also helps in understanding the relationship and function of the software and hardware of a computer network

![image](https://github.com/user-attachments/assets/0f118561-d3c3-4128-a4f1-171af0832da4)



## 1. Application Layer:
 - Any software which interacts directly with one human to another comes under Application Layer. e.g :- WhatsApp, Gmail, Web browser etc.
 - Different types of protocol given below is used in Application Layer - (let's discuss some protocol in details)

   ### HTTP (Hypertext Transfer Protocol)
   - Functionality: It is a client server stateless (means it never stores any data of client)protocol, and it tells us how it request any data from the server and also tells us how the server will send the data back to the client.
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
   - SMTP is used in sending and receiving any email from senders SMTP server to Receiver's SMTP server
   - POP is used to download any email from POP server
    
   ### FTP (File Transfer Protocol)

   - FTP is used to download, upload and transfer files from one host to another host.

## 2. Presentation Layer
- This layer actually tells about the Format of Data(just remember this 🙂) means when you see a webpage like google.com or YouTube.com, there you can see many videos, images, thumbnail of videos, comments and all.
-  So the presentation layer helps to represent the data of any format.

## 3. Session Layer
- When the data is moving to Session Layer, so session layer is actually create and maintain the sessions with the time frame.
- Whenever you open any bank website, it has a time limit. If you are away from your keyboard for some time, then that session will automatically log out. 
- If you are not using your keyboard or mouse pointer or anything, then the session will log out automatically by a session layer algorithm written by the developers. This is the responsibility of Session Layer.

## 4. Transport Layer
- By this Layer the Data in converted into small segments means this layer divides the data in multiple chunks or parts. 
- This layer is also responsible for sequencing the segment, means it will actually add the serial number on each data segment. 
- Because when the data is travelling from one PC to another PC over the internet, so might be there is a chance that one part/segment of data will be dropped. 
- So when the data will be reached from Host-A to Host-B then B will check oK! I got 1,3,4,5 segments, but I have not received the no. 2 segment. Then B will send request again to A that can you please retransmit again no. 2 segment. This layer use some checksum, and it takes care of congestion control. 
- And this layer is responsible for retransmission also.
- TCP and UDP is used in this layer.

  ### TCP (Transmission Control Protocol)

    - In this protocol, if any segments of data is transmitting from Host A to Host B, the destination (Host B) will send back a receipt/acknowledgement to sender (Host A).  
    - Means whenever we send data with TCP, it actually takes care of acknowledgement.  
    - So this protocol is reliable, and also it retransmits the data segment if any segment is dropped.
    - In network language, this protocol is connection oriented because it believes in making connection end to end. It takes 20 bytes to add TCP information on each segment. 
    - This information contains port numbers. Port number is in which application you want to send your data is recognized by port numbers. e.g. :- HTTP - port 80, MongoDB - port 27017, SQL - port 1433 etc.

  ### UDP (User Datagram Protocol)
    - This protocol is connectionless, means it does not make any connection with receiver to check whether all data segments are reached successfully to the receiver or not. 
    - So it is not reliable since it does not take care of any acknowledgement.  - Retransmission is not possible with this protocol. 
    - It takes 8 bytes to add UDP information on each segment. These 8 bytes contain port number, same like TCP.

![image](https://github.com/user-attachments/assets/3e8cb1e6-2e92-43f6-bf07-b70dbba0288e)



## 5. Network Layer
- In this layer, each data segment is converted into Packets. 
- In each packet's Source IP address (sip) and the destination IP address (dip) is added by this layer. 
- Actually, Packets is the abstraction (layer) of Segments. 
-   Router works in this layer for connecting one Host with another Host (different network).
## 6. Data Link Layer
- In this layer, each packet is converted into Frame. 
- In each packet, the source MAC address and the destination MAC address (physical address of the device)is added by this layer.
-  Frame is another abstraction (layer) of Packets which contain both the MAC addresses. 
- Switch works in this layer for selecting which device it has to send that data connected with that Switch.

## 7. Physical Layer
- In this layer, data will be converted into digital signal(0 and 1) is called Encoding. 
- Then the signal will travel via cable to another device (receiver).
-  Now, these above 7 processes will also be occurred in the receiver device.

## TCP/IP Model
 - This model is a real model which actually works in real. This model consist of 4 layers.
    - Application Layer = (Application Layer + Presentation Layer + Session Layer) of OSI model
     - Transport Layer
     - Network Layer
     - Network Interface Layer = (Data Link Layer + Physical Layer) of OSI model


