# 3-Tier Application setup and Deployment Configuration.
 
###  1.Initial Validation:
       
  ◦ All components (front-end, back-end, and database) to be installed and deployed on a single public machine.
        
  ◦ Ensure end-to-end functionality, where records are saved in the database, and the application works successfully in the browser.

###  2.Set-up for Client requirement:
      
  ◦ Front-end: In V net,Deploy front-end VM in a seperate subnet which can access by the user from public internet.Its a gateway or entrypoint VM.
       
  ◦ Backend: In same Vnet, Deploy  back-end VM in a seperate subnet with no direct public access.
       
  ◦ Database: In same Vnet,Deploy Database Vm in a seperate subnet with no direct public access.

### 3.Access Control:
      
  ◦ Frontend: Accessible from the internet; can SSH into the backend.
        
  ◦ Backend: Can SSH into the database; no direct public access.
        
  ◦ Database: No direct SSH access from frontend; only accessible from backend.
  
### Summary:
  
  1.Application run on browser successfully

     
  2. SSH rules are defined 
    
  • Frontend can SSH to the backend.
  
  • Backend can SSH to the database.
    
  • Frontend cannot SSH to the database.
