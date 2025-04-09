### **Step 1:** Select "**Trigger**"

![Screenshot from 2025-04-09 18-38-28](https://github.com/user-attachments/assets/282613b7-c36b-4d4a-9ce8-e0b35b976b32)

### **Step 2**: Select Actions "**Azure**"

- Select **Get Advisor Recommendations**.
- Click the Get Advisor Recommentations >>> Right corner >>>> connections :Azure(Crreated in previous file)
- Select Subscriptions : Free trail
- Filter by:Resourse group
- Resourse group name:rg-ranjitha
  
![Screenshot from 2025-04-09 18-39-07](https://github.com/user-attachments/assets/72e6de4f-b85b-4f21-bf25-25aeae869498)

### Check Right corner

![Screenshot from 2025-04-09 18-41-04](https://github.com/user-attachments/assets/50e7dd45-f337-4c76-8e92-59e4bec78e03)


### **Step 3:** Select Actions "**Loop on Items**"

Select Get advisor recommentations from data selector in side pannel. 

![image](https://github.com/user-attachments/assets/87ee6ce1-7713-4ebb-82fe-d98bdb20376e)


### **Step 4:** Inside Loop Select Actions "**Azure"** >>> Azure CLI
Azure CLI command to fetch resourse id's from Get advisor recommendations
```
az advisor recommendation list --category Cost --query "[].resourceMetadata.resourceId" --output tsv
```
### Step 5 :Under Azure CLI,select Actions "OpenOps Tables"  >>>>>>  "Get records"

To Get email address of owner  >>> Select **Tag Owner mapping**

![Screenshot from 2025-04-09 18-55-12](https://github.com/user-attachments/assets/c989f4e7-9fed-4c3d-9044-bf10ae15fc8d)

### Step 6 : Under Get records ,select Actions "Openops Tables"   >>>>>>>   "Add or update record"

- Select **Opportunites**
- Fields to update >>> Add items
- Status     : Created
- Owner :Tag above Get rocord >>>> Owner email
- Workflow :Azure advisor recommentation workflow
- Resourse ID :Tag Step:4
- Risk:Medium

### Step 7:Select Actions "Approval"
 - Create Approval links

### Step 8:Selcet Actions "SMTP"

 - Select connection created in above file:smtp
 - From email:Tag Step:5 email adddress
 - To :Tag Step:5 email address
 - Subject:Advisor Recommendations
 - Body: Tag the link creates above step:7

### Step 9: Select Actions "Approval"

- Wait for Approval

### Step 10:Select Actions "Conditions"

![image](https://github.com/user-attachments/assets/6a8cd405-4cf4-4db7-add6-7ce05e974e2f)

### Step 11:End workflow

### Click publish

### Check "Runs"





































