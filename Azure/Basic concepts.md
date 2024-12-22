

# Basic concepts

## 1. Introduction

- Azure active Directory
- Management group
- Subscription
- Resource group
- Resource

## 2.Azure Active Directory
  
-  Azure AD is a microsoft's cloud-based identity and access management service.
- It enables users to sign up for various services and access them from any location via the cloud using a single username and password.
###  2.1 Resources

   - This solution facilitates access to thousands of additional SaaS applications, the Azure portal, and `external resources` like Microsoft 365 for your staff members. 
   - They can also access `internal resources` like apps on your business intranet network and any cloud apps created by your own company.

### 2.2  Why Azure Active Directory?
  - In large organization with a lot of developers, Some Azure services must be available to all developers for them to perform their responsibilities. When the administrator gives them a unique username and password for each service, they can access services like databases, virtual machines, or Azure storage services. It might be challenging for administrators and employees to manage many user logins at once. 

  - Azure Active Directory (AD) enters the scene in this situation. Administrators can easily manage numerous user logins with Azure AD. To access each service, administrators must provide a single login and password in Microsoft Azure. You can also manage the permissions on Azure storage disks which contain important data of organizations.

### 2.3.Tenant 
- where each tenant represents a dedicated and isolated instance of Azure AD. 
- There are two types of tenant
     
  - Azure Active Directory:want to add users or create group for particular organization or particular business or a school or a college.
  - Azure Active Directory B2C:that is business to consumer.Now, if you want to create an application that you want to expose to the public at large, then you would use B2C.

### 2.4. Creating An account with default tenant

- Azure create account (https://azure.microsoft.com/en-in/pricing/purchase-options/azure-account?msockid=2c32100c31c467461a6800da30bb6655)
- Click "Try Azure for free"
- Sign in with your mail-id
- Create password and then enter the verify email code send to mail id
- After sign in, fill the details
- Click "Next", for 'Identify by card'.
- Fill the card details, Only VISA/MASTERO credit or Debit cards accepted.
- After successful transcation, Account will be created.

### 2.5.Default tenant Directory
  
- signin to Azure account
- After account creation it automatically create default directory in the name of mailid.
- Search for Azure active directory,it display as (Microsoft Entra ID, Azure Active Directory)
- In that we can see the tenant ID,domain name etc.

  ![Screenshot from 2024-12-22 12-54-45](https://github.com/user-attachments/assets/0f748661-45bb-44a8-925b-c3f08356b6c5)


### 2.6.Create new user

- In Default Directory page , the right side menu bar shows 'manage'.
- In that we can see 'users'.By clicking that we can create new user.
- Fill the details,Domain name will be taken from default directory created above and auto set password had given for that new user.copy it and click create.
- User name wil be added in 'All users'.

 ![Screenshot from 2024-12-22 13-25-32](https://github.com/user-attachments/assets/84f64d53-367f-404a-ab13-1feeca1ebfaa)



    
