
# Create Subscription,Resourse groups,Resourses

Step 1:Sign in to Azure portal

Step 2:Create subscription          
     
- Search Subscription -->For free subscription (free trail) will generate automatically after Azureportal account created successfully 

Step 3:Create Users

- Search User --> New user --> create new user --> Fill the details --> review and create
  
Step 4:Invite guest user 

 -   user-->New user --> add external user-->fill the details by giving guset mailid -->assign and create--> invitation send to guest.Guest have to accept that invitation

Step 5:Assign role for guestuser
 
  -  resourse group -->rg-Ranjitha -->Access control (IAM) --> Add Role Assignment --> click the role(reader,owner,contributor) --> members -->select members -->assign and create

Step 6:Check assigned roles

  -  Check in default directory -->users -->All user -->click guset user --> check for Assigned roles for guest user.

Step 7:Resourse groups 
    
 -   Under Subscription Resource group will be created.We can Create more than one resource group under one subscription.
 -   search resourcegroup -->create resourse group -->Add subscription name as freetrail -->Resourcegroup name(rg-Ranjitha) -->region -->Review and create


Step 8:Create Resourse

- Under Resoure group morethan one resourses can be created. 
  -  Check as Virtualmachine(resourse)
  -  Add Subscription name,resource-group name,vm name 
  -  Authentication details
      
      - Use SSH type-->Username,Generate newkeypair,keytype,keyname

     - Use Password type -->User name,Password
  -  Allow inbound-ports that have to allow

Step 8:Other Resourses
   - Disk,Networking as any other resourse required,can give the details

Step 9:Review and create
