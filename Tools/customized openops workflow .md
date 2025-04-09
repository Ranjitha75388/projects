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


