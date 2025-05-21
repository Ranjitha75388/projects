### STEP 1: Install gcloud CLI (Google Cloud SDK)
```
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-451.0.1-linux-x86_64.tar.gz
tar -xvzf google-cloud-sdk-*.tar.gz
./google-cloud-sdk/install.sh
```
### Step 2 :To Start a new shell reload the environment
```
source ~/.bashrc
```
```
gcloud init
```
### Step 3:Check version
```
gcloud version
```
![image](https://github.com/user-attachments/assets/19d44524-87d8-4526-bf59-ebc29b05b9ee)

### Step 4:Terraform Authenticates with GCP.

- #### Method 1:Application Default Credentials (ADC) to authenticate with Google Cloud.
```
   gcloud auth application-default login
```
- Google created a file at:
```
   ~/.config/gcloud/application_default_credentials.json
```
- #### Method 2: Using a Service Account Key File (Alternative Way)

This is used in automation, CI/CD, or team setups.

#### Step 1: Create a Service Account

-  Go to the GCP Console:
   [Link](https://console.cloud.google.com/iam-admin/serviceaccounts)

- Click "Create Service Account"

- Fill in:

   - Name: terraform-sa

   - ID: auto-filled (e.g., terraform-sa)

   - Description: Terraform deployment account

- Click "Create and Continue"

#### Step 2: Assign Permissions

- Assign required roles. 

#### Step 3: Create and Download the Key

- In the final step, click "Done"

- Go to the service account list

- Find name (terraform-sa) → Click the 3-dot menu → Manage keys

- Click "Add Key" → "Create new key"

     -   Choose: JSON

     -   Click Create

-  This will download a .json key file to our system. Save it as

/home/logesh/keys/terraform-sa.json

#### Step 4: Set Environment Variable

In terminal:
```
export GOOGLE_APPLICATION_CREDENTIALS="/home/logesh/keys/terraform-sa.json"
```
#### Step 5: Update Terraform Provider (optional)
```
provider "google" {
  project     = "your-project-id"
  region      = "us-east1"
}
```
### Step 5:To Check Which Credentials is Using
```
gcloud auth list
```
![image](https://github.com/user-attachments/assets/328f2ee0-e727-4414-a826-d8d1f10c7184)

### Step 6 :Run Terraform from Machine

cd /path/to/.tf file
```
terraform init 
terraform plan
terraform apply
```
### Step 7:Sample file to create vpc with one subnet
```
nano vpc.tf
```
```
provider "google" {
  project = "nomadic-rite-456619-e1"
  region  = "us-central1"
}

resource "google_compute_network" "ranjitha_vpc" {
  name                    = "ranjitha-tf-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "pub_subnet" {
  name          = "public-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-east1"
  network       = google_compute_network.ranjitha_vpc.id
}
```
![image](https://github.com/user-attachments/assets/fa5f8ced-c058-4760-9700-162cc9e15ce2)

### Step 8: Check in console
![image](https://github.com/user-attachments/assets/489b1654-f708-4703-8222-794933f4e847)
