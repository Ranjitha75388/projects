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

## Azure CLI

1. Install az in Terminal
```
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az --version
```
2.List of vm,disk
```
az resource list --resource-group rg-ranjitha \
  --query "[?type=='Microsoft.Compute/virtualMachines' || type=='Microsoft.Compute/disks'].{Name:name, ID:id, Type:type}" \
  -o json
```
3.Specific Disk
```
az monitor metrics list \
  --resource "/subscriptions/07ee8e08-7d5b-420b-9bec-bc242df1c043/resourceGroups/rg-ranjitha/providers/Microsoft.Compute/disks/<Disk name>" \
  --metric "Composite Disk Read Bytes/sec" "Composite Disk Write Bytes/sec" \
  --aggregation "Average" \
  --interval PT1H \
  --query "value[].timeseries[].data[].average" -o json
```
4.list all resourses
```
az resource list --resource-group rg-ranjitha --query "[].{name:name, type:type}" -o json
```
5.Lists disks that are not attached to any VM.
```
az disk list --resource-group <your-resource-group> --query "[?managedBy==null].[name, id]" -o table
```
6.unused nsg 
```
az network nsg list --query "[?(!subnets && !networkInterfaces)].[name, id]" -o table
```
7.unused public ip
```
az network public-ip list --query "[?ipConfiguration == null].[name, id]" -o table
```
8.unused storage account
```
az storage account list --query "[?properties.provisioningState=='Succeeded'].[name, properties.creationTime]" -o table
```
9.list of subnet
```
az network vnet subnet list --resource-group <RESOURCE_GROUP> --vnet-name <VNET_NAME> -o table
```
10.Listing Unused Stopped VMs)
```
az vm list -d --query "[?powerState=='VM deallocated'].{Name:name, Status:powerState}" -o table
```
11.VM WITHSTATUS
```
az vm list --show-details --query "[].{Name:name, Status:powerState, ResourceGroup:resourceGroup}" --output table
```
12.WITHALL DETAILS ABOUT VM
```
az vm list --show-details --query "[].{
    Name:name, 
    Status:powerState, 
    ResourceGroup:resourceGroup, 
    ResourceID:id,
    Size:hardwareProfile.vmSize,
    Location:location,
    OS:storageProfile.osDisk.osType,
    DiskSizeGB:storageProfile.osDisk.diskSizeGb,
    PublicIP:publicIps,
    PrivateIP:privateIps,
    ProvisioningState:provisioningState
}" --output table
```
13.VM WITH SIZE
```
az vm list --show-details --query "[?powerState=='VM running'].{Name:name, ResourceGroup:resourceGroup, Size:hardwareProfile.vmSize}" -o table
```
14.STOP THE VM
```
az vm deallocate --resource-group MyResourceGroup --name openops-vm
```
15.Resize to downsize
```
az vm resize --resource-group <your-resource-group> --name <your-vm-name> --size Standard_B1s
```
16.Check current-status of vm
```
az vm get-instance-view --name <private-vm> --resource-group rg-ranjitha --query "instanceView.statuses[?code.starts_with(@, 'PowerState/')].displayStatus" --output table
```
17.Specific Disk
```
az resource list --resource-type "Microsoft.Compute/disks" --query "[?managedBy==null && name=='<test-disk>'].{ResourceID:id, Name:name, Type:type, Location:location, State:'Unused', RecommendedAction:'Evaluate if you still need this disk and delete if unnecessary'}" -o json
```
18.CPU usage of vm
```
az monitor metrics list \
    --resource "/subscriptions/07ee8e08-7d5b-420b-9bec-bc242df1c043/resourceGroups/rg-ranjitha/providers/Microsoft.Compute/virtualMachines/<vm-demo>" \
    --metric "Percentage CPU" \
    --interval PT1M \
    --aggregation Average \
    --query "value[0].timeseries[0].data[*].{Time:timeStamp, CPU_Percentage:average}" \
    --output table
```
19.list all services in resourse group
```
az resource list --resource-group rg-ranjitha --query "[].{Name:name, Type:type, Location:location}" -o table
```
20.list under compute resourses
```
az resource list --resource-group rg-ranjitha --query "[?starts_with(type, 'Microsoft.Compute')]" -o table
```
21. VM: Standard_B1ls (cheapest, 1 vCPU, 0.5 GiB RAM)
```
 az vm create --resource-group demo-rg --name demo-vm --image UbuntuLTS --size Standard_B1ls --admin-username azureuser --generate-ssh-keys
```
22.Storage
```
az storage account create --name openopsstorage --resource-group demo-rg --sku Standard_LRS
```
23.Blob Storage (Cool/Archive tier)
```
az storage container create --name demo-container --account-name openopsstorage
```
24.Networking
```
az network public-ip create --resource-group demo-rg --name demo-ip --sku Basic
```
25. Azure SQL Database (Serverless, Free Tier)
```
az sql server create --name demo-sqlserver --resource-group demo-rg --location eastus --admin-user adminuser --admin-password YourPassword123!
```
26. list all services in resourse group
```
az resource list --resource-group rg-ranjitha --query "[].{Name:name, Type:type, Location:location}" -o json
```
27.list under compute resourses
```
az resource list --resource-group rg-ranjitha --query "[?starts_with(type, 'Microsoft.Compute')]" -o table
```
28.fetch only vm from group
```
az resource list --resource-group rg-ranjitha --query "[?type=='Microsoft.Compute/virtualMachines'].{Name:name, Type:type, Location:location}" -o table
```
29. Fetch ressourse id's from group of resourses
```
az resource list --resource-group rg-ranjitha --query "[].id" -o table
```
30.fetch disk and vm seperately
```
az resource list --resource-group rg-ranjitha --query "{

    VMs: [?type=='Microsoft.Compute/virtualMachines'],

    Disks: [?type=='Microsoft.Compute/disks']

}" -o json
```


































