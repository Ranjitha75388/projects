# 1. Build and Push a Docker Image to Azure Container Registry (ACR) from GitHub Actions
## Step 1: Create an Azure Container Registry (ACR)

   - Sign in to Azure Portal
   - Search for Container Registry and click Create.
    - Fill in the details:
        - Subscription: Select your subscription.
        - Resource Group: Create a new one or select an existing one.
        - Registry Name: Enter a unique name (e.g., myacr).
        - Region: Choose your preferred Azure region.
        - SKU: Select standard
  -  Click Review + Create and then Create.

  ##  Step 2: Get ACR Login Credentials

  -  Go to your Container Registry in Azure Portal.
  -  Under Settings, click Access Keys.
  -  Enable Admin User.
  -  Copy the following details for GitHub Actions:
        Login Server:containeregistry.azurecr.io
        Username   : containeregistry                        :
        Password   :k/HMPW5Sqdc/yc7L3ZSPsetpJmiWkjchhff2VDr6oa+ACRBoRFQa
        Password 2 :kcT/5cCeftNhozR8PflpmtripQBRdbBYj1yirfZ1ME+ACRCElq00
     ![image](https://github.com/user-attachments/assets/b11674e4-03aa-4315-acaf-12c79429ee3b)


## Create Service principal ID 
What is a Service Principal ID?

A Service Principal is an Azure identity that allows applications (like GitHub Actions) to authenticate and interact with Azure without using a user account.

The Service Principal Client ID (AZURE_CLIENT_ID) is an application (client) ID that uniquely identifies the Service Principal in Azure.

## How to Create a Service Principal in Azure Portal
Step 1: Go to Azure Active Directory

    Sign in to Azure Portal.
    In the left menu, click Azure Active Directory.
    Click App registrations.
    Click + New registration.

Step 2: Register a New Application

    Name → Enter a name :application-service-principal-ID.
    Supported account types → Choose Single tenant.
    Redirect URI → Leave it empty (not required for this use case).
    Click Register.

Step 3: Get the Required IDs

After registering, you will see the Application Overview page. Copy these values:

    Application (client) ID → This is your AZURE_CLIENT_ID.
    Directory (tenant) ID → This is your AZURE_TENANT_ID.

 Step 4: Create a Client Secret

    In the left menu, click Certificates & secrets.
    Click + New client secret.
    Enter a description (e.g., GitHub Secret).
    Set the expiration period (e.g., 1 year).
    Click Add.
    Copy the Value (not the Secret ID) → This is your **AZURE_CLIENT_SECRET**:XMp8Q~UcNLS5QKX_MrRYkF4T87uRqNpYE29C6c9d
    secret-id:bdc05a07-9926-4ee3-856d-f8064d5e8976 (no need)
## Important: The client secret will be shown only once. Copy it immediately.   


Step 5: Assign Permissions to the Service Principal

    Go to Subscriptions in the Azure Portal.
    Select your Azure Subscription.
    Click Access control (IAM).
    Click + Add role assignment.
    Choose Contributor role.
    In the Members tab:
        Click + Select members.
        Search for the Application Name (e.g., GitHub-Actions-SP).
        Select it and click Next.
    Click Review + Assign.

## Step 3: Configure GitHub Secrets

    Go to your GitHub repository.
    Navigate to Settings → Secrets and variables → Actions.
    Add the following secrets:
        AZURE_CLIENT_ID → acb9e866-d3f7-4c17-886c-f06579005b9e
        AZURE_TENANT_ID → 62d68a08-d1c9-46f7-9a34-fb1738cf4c7d
        AZURE_SUBSCRIPTION_ID → 07ee8e08-7d5b-420b-9bec-bc242df1c043
        ACR_NAME → containeregistry
        REGISTRY_USERNAME → containeregistry
        REGISTRY_PASSWORD → k/HMPW5Sqdc/yc7L3ZSPsetpJmiWkjchhff2VDr6oa+ACRBoRFQa


## Configure Federated Credentials in Azure

To allow GitHub Actions to authenticate using OIDC (OpenID Connect), you must configure Federated Identity Credentials in Azure AD.
Fix: Add a Federated Credential for GitHub

    Go to Azure Portal → Azure Active Directory
    Click App Registrations
    Select your Service Principal (App)
    Go to "Certificates & Secrets" → "Federated Credentials"
    Click "Add a credential"
    Select "GitHub Actions"
    Set the following values:
        Organization: Your GitHub Organization (your-org-name)
        Repository: Your GitHub Repository (your-repo-name)
        Entity Type: Environment
        Name: GitHub-Actions
        Audience: api://AzureADTokenExchange
    Click Create

![image](https://github.com/user-attachments/assets/f3da2147-142f-4b7b-9da9-fbd188bceaf7)

## push image to ACR
```
name: Build & Push to ACR
on:
  push:
    branches:
      - main

permissions:
  id-token: write   # This allows OIDC authentication
  contents: read

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout Repository
      uses: actions/checkout@v3

    - name: Login to Azure
      uses: azure/login@v1
      with:
        client-id: ${{ secrets.AZURE_CLIENT_ID }}
        tenant-id: ${{ secrets.AZURE_TENANT_ID }}
        subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}

    - name: Login to Azure Container Registry (ACR)
      run: |
        echo "${{ secrets.REGISTRY_PASSWORD }}" | docker login ${{ secrets.ACR_NAME }}.azurecr.io -u ${{ secrets.REGISTRY_USERNAME }} --password-stdin

    - name: Build and Push Frontend
      run: |
        docker build -t ${{ secrets.ACR_NAME }}.azurecr.io/frontend:latest ./react-hooks-frontend
        docker push ${{ secrets.ACR_NAME }}.azurecr.io/frontend:latest

    - name: Build and Push Backend
      run: |
        docker build -t ${{ secrets.ACR_NAME }}.azurecr.io/backend:latest ./springboot-backend
        docker push ${{ secrets.ACR_NAME }}.azurecr.io/backend:latest
```
## Check image added in ACR

![image](https://github.com/user-attachments/assets/da3f83c0-fd32-4a96-9658-a49c76f20456)

# Create vnet and add subnet only for container app environment

![image](https://github.com/user-attachments/assets/febee709-b940-428b-b435-99505cf5d9bd)


# 2. Manually Deploy the Image to Azure Container Apps
Step 1: Create an Azure Container App

    Go to Azure Portal.
    Search for Container Apps and click Create.
    Fill in the details:
        Subscription: Select your subscription.
        Resource Group: Use the same one as the ACR.
        Name: Choose a unique name (e.g., my-container-app).
        Region: Select a preferred Azure region.
        Environment: Click Create new and provide a name.

Step 2: Configure the Container Image

    In the Container Settings section:
        Choose Azure Container Registry (ACR).
        Select your ACR.
        Choose the image you pushed (my-app:latest).
    Click Next: Review + Create and then Create.

Step 3: Get the Application URL

    Go to Azure Portal → Container Apps.
    Select your Container App.
    Under Settings, click Ingress.
    Copy the URL and test it in your browser.
![image](https://github.com/user-attachments/assets/e5f8fc88-0167-42ee-8cb0-fac1374a6a17)

NEXT:CONTAINER
![image](https://github.com/user-attachments/assets/33a62e74-6dec-42d7-be9d-9607d849ae6c)

NEXT:INGRESS
![image](https://github.com/user-attachments/assets/6001fdc7-43df-4b0a-a9de-1855ba83720a)

REVIEW+CREATE

Copy the application URL in overview 
![image](https://github.com/user-attachments/assets/72ee3a76-f0fe-44c8-9a1e-76514f7c7d57)

Run the URL in chrome
![Screenshot from 2025-03-08 22-04-24](https://github.com/user-attachments/assets/b58895c3-de92-4f12-85ba-433e3d14b3f4)



## only one container app environment can be used for subscription.so the above created frontend environment can be use for backend container also.

## Backend container
![image](https://github.com/user-attachments/assets/834cac9e-e5ad-46f6-b734-68e9098aff13)

NEXT:CONTAINER
![image](https://github.com/user-attachments/assets/d45de3c2-8c73-43bd-8a51-f41ac0e1ab05)

NEXT:INGRESS
![image](https://github.com/user-attachments/assets/a122d9ca-ba60-4a9c-9484-b565efedcc4b)

REVIEW+CREATE

![image](https://github.com/user-attachments/assets/896c11f4-329f-41bc-bcc3-43f02d071361)



### update in frontend   --- src/service/employee.service.js (backend URL)

![image](https://github.com/user-attachments/assets/5bbaf8b6-d15c-46e9-86df-f0c3dcfc3178)



![image](https://github.com/user-attachments/assets/0745ffe8-a421-4023-88d1-e0e5a28a6368)







# Automatic process



### github secrets


![image](https://github.com/user-attachments/assets/1d1febdc-cef2-4547-94e7-c89733f13d7b)


CONTAINERAPPS_ENVIRONMENT   : managedEnvironment-rgranjitha-823e
CONTAINER_APP_NAME_AUTO     : frontend-auto
RESOURCE_GROUP              : rg-ranjitha

### workflow file

```
name: Deploy Frontend to Azure Container Apps

on:
  push:
    branches:
      - main
  workflow_dispatch:

permissions:
  id-token: write
  contents: read

jobs:
  build-and-deploy-frontend:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Code
        uses: actions/checkout@v3

      - name: Log in to Azure
        uses: azure/login@v1
        with:
          client-id: ${{ secrets.AZURE_CLIENT_ID }}
          tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}

      - name: Log in to Azure Container Registry (ACR)
        run: |
          az acr login --name ${{ secrets.ACR_NAME }}

      - name: Build and Push Docker Image (Frontend)
        run: |
          cd react-hooks-frontend
          docker build -t ${{ secrets.ACR_NAME }}.azurecr.io/my-frontend:latest .
          docker push ${{ secrets.ACR_NAME }}.azurecr.io/my-frontend:latest

      - name: Deploy Frontend to Azure Container Apps
        run: |
          set -e  # Stop script if any command fails

          # Deploy or update the container app
          az containerapp up \
            --name "${{ secrets.CONTAINER_APP_NAME_AUTO }}" \
            --resource-group "${{ secrets.RESOURCE_GROUP }}" \
            --environment "${{ secrets.CONTAINERAPPS_ENVIRONMENT }}" \
            --image "${{ secrets.ACR_NAME }}.azurecr.io/my-frontend:latest" \
            --ingress external \
            --target-port 3000 \
```

Check in ACR --->repository --->   image added 

![image](https://github.com/user-attachments/assets/2f70011e-4e84-4a92-be2a-47c8b492acf1)

In container app

![image](https://github.com/user-attachments/assets/aaf4180a-24e7-4f77-a835-d5be8ebd41d6)

check with URL

![image](https://github.com/user-attachments/assets/a1681ba6-f79c-46b3-80e0-e69bd02da72b)

## backend


in secret add 
CONTAINER_APP_NAME_AUTO_BACKEND   : backend-auto



```
name: Deploy backend to Azure Container Apps

on:
  push:
    branches:
      - main
  workflow_dispatch:

permissions:
  id-token: write
  contents: read

jobs:
  build-and-deploy-backend:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Code
        uses: actions/checkout@v3

      - name: Log in to Azure
        uses: azure/login@v1
        with:
          client-id: ${{ secrets.AZURE_CLIENT_ID }}
          tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}

      - name: Log in to Azure Container Registry (ACR)
        run: |
          az acr login --name ${{ secrets.ACR_NAME }}

      - name: Build and Push Docker Image (backend)
        run: |
          cd springboot-backend
          docker build -t ${{ secrets.ACR_NAME }}.azurecr.io/my-backend:latest .
          docker push ${{ secrets.ACR_NAME }}.azurecr.io/my-backend:latest

      - name: Deploy backend to Azure Container Apps
        run: |


          # Deploy or update the container app
          az containerapp up \
            --name "${{ secrets.CONTAINER_APP_NAME_AUTO_BACKEND }}" \
            --resource-group "${{ secrets.RESOURCE_GROUP }}" \
            --environment "${{ secrets.CONTAINERAPPS_ENVIRONMENT }}" \
            --image "${{ secrets.ACR_NAME }}.azurecr.io/my-backend:latest" \
            --ingress external \
            --target-port 8080 \
```
container registry

![image](https://github.com/user-attachments/assets/2e0a9ef0-9938-4168-9168-c7a6d2fa2f19)





container app
![image](https://github.com/user-attachments/assets/de8780b1-646f-460a-817f-a3c92606913f)










URL
![image](https://github.com/user-attachments/assets/737aec3d-ac16-4097-bd18-3629170ffb8d)
