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

#### Method 1:Application Default Credentials (ADC) to authenticate with Google Cloud.
```
   gcloud auth application-default login
```
- Google created a file at:
```
   ~/.config/gcloud/application_default_credentials.json
```
#### Method 2: Using a Service Account Key File (Alternative Way)

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
  project     = "our-project-id"
  region      = "us-east1"
}
```
### Step 5:To Check Which Credentials is Using
```
gcloud auth list
```
![image](https://github.com/user-attachments/assets/328f2ee0-e727-4414-a826-d8d1f10c7184)


### Step 6:Sample file to create vpc with one subnet
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

### Step 8:Run Terraform
```
terraform init
terraform apply
```

### Step 9 :Check in console

![image](https://github.com/user-attachments/assets/489b1654-f708-4703-8222-794933f4e847)

# Manuall setup guide for creating vm instance

1. Create a VPC Network

    Go to: VPC network > VPC networks

    Click "Create VPC network"

    Name: custom-vpc

    Subnet creation mode: Custom

    Click Add Subnet

        Name: public-subnet

        Region: us-central1

        IP range: 10.0.1.0/24

        Enable "Private Google Access": ✅ No

    Click Add Subnet again:

        Name: private-subnet

        Region: us-central1

        IP range: 10.0.2.0/24

        Enable "Private Google Access": ✅ Yes

    Leave everything else as default and click Create

🔐 2. Create Firewall Rules

Go to: VPC network > Firewall
Rule 1: Allow Internal Communication

    Name: allow-internal

    Network: custom-vpc

    Direction: Ingress

    Action: Allow

    Targets: All instances in the network

    Source IP Ranges: 10.0.0.0/16

    Protocols: Allow all

Rule 2: Allow SSH to Public VM

    Name: allow-ssh-public

    Network: custom-vpc

    Direction: Ingress

    Action: Allow

    Targets: Specified target tags

        Target Tag: public-vm

    Source IP Ranges: 0.0.0.0/0

    Protocols: TCP: 22

Click Create both rules.
🖥️ 3. Create a Public VM (with External IP)

    Go to: Compute Engine > VM instances

    Click "Create Instance"

    Name: public-vm

    Region: us-central1, Zone: us-central1-a

    Machine type: e2-micro

    Boot disk: Default (Debian)

    Firewall: Check "Allow HTTP" and "Allow SSH"

    Networking > Network interfaces

        Network: custom-vpc

        Subnet: public-subnet

        External IP: Ephemeral

        Network tags: public-vm

    Click Create

🔒 4. Create a Private VM (No External IP)

    Create another VM

    Name: private-vm

    Zone: us-central1-a

    Machine type: e2-micro

    Boot disk: Debian

    Firewall: No options need checking

    Networking > Network interfaces

        Network: custom-vpc

        Subnet: private-subnet

        External IP: None

    Click Create

🌐 5. Set up Cloud NAT (for Private VM)

    Go to: VPC network > NAT gateways

    Click "Create NAT Gateway"

    Name: cloud-nat

    Region: us-central1

    Router:

        If no router exists, click "Create new router"

            Name: nat-router

            Region: us-central1

            Network: custom-vpc

    NAT IP allocation: Auto

    Subnetworks: Select "All subnetworks"

    Click Create

✅ Now your private-vm can access the internet (e.g., apt-get, curl, etc.) without a public IP.
🗃️ 6. Create Cloud SQL with Private IP

    Go to: SQL > Create Instance

    Choose PostgreSQL or MySQL

    Name: db-instance

    Choose a password, region: us-central1

    Under Connectivity > Networking

        Enable Private IP

        Choose custom-vpc > private-subnet

        Click Add network if needed

    Disable Public IP (optional, for security)

    Click Create

Once created:

    Go to Instance details > Connections

    Copy the Private IP (10.100.x.x)

🔗 7. Connect Private VM to Cloud SQL (Manual Test)

SSH into private-vm (via public-vm or IAP tunnel):

# Install mysql/postgres client (based on your DB)
sudo apt update
sudo apt install mysql-client     # or postgresql-client

# Connect (example for MySQL)
mysql -u <user> -p -h 10.100.x.x


# resourse tf

```
provider "google" {
  project     = "your-gcp-project-id"
  region      = "us-central1"
  credentials = file("/path/to/your/service-account.json")
}

# VPC
resource "google_compute_network" "drip_nonprod" {
  name                    = "drip-nonprod"
  auto_create_subnetworks = false
}

# Subnets
resource "google_compute_subnetwork" "public_subnet" {
  name                     = "drip-nonprod-public-subnet"
  ip_cidr_range           = "10.10.1.0/24"
  region                  = "us-central1"
  network                 = google_compute_network.drip_nonprod.id
}

resource "google_compute_subnetwork" "private_subnet" {
  name                     = "drip-nonprod-private-subnet"
  ip_cidr_range           = "10.10.2.0/24"
  region                  = "us-central1"
  network                 = google_compute_network.drip_nonprod.id
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "database_subnet" {
  name                     = "drip-nonprod-database-subnet"
  ip_cidr_range           = "10.10.3.0/24"
  region                  = "us-central1"
  network                 = google_compute_network.drip_nonprod.id
  private_ip_google_access = true
}

# Private Service Access IP Range
resource "google_compute_global_address" "private_connection_ip" {
  name          = "drip-nonprod-private-connection-ip"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.drip_nonprod.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.drip_nonprod.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_connection_ip.name]
}

# Firewall Rules
resource "google_compute_firewall" "allow_http" {
  name    = "drip-nonprod-allow-http"
  network = google_compute_network.drip_nonprod.id

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_https" {
  name    = "drip-nonprod-allow-https"
  network = google_compute_network.drip_nonprod.id

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "bastion_ingress" {
  name    = "drip-nonprod-bastion-ingress"
  network = google_compute_network.drip_nonprod.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["YOUR_BASTION_SOURCE_IP"] # Replace with allowed IP range
  target_tags   = ["bastion"]
}

resource "google_compute_firewall" "iap_ssh" {
  name    = "allow-ssh-from-iap-drip-nonprod"
  network = google_compute_network.drip_nonprod.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"] # IP range for IAP
  target_tags   = ["iap-access"]
}

# Cloud Routers
resource "google_compute_router" "nonprod_router" {
  name    = "drip-nonprod-public-router"
  network = google_compute_network.drip_nonprod.id
  region  = "us-central1"
}

resource "google_compute_router" "prod_router" {
  name    = "drip-prod"
  network = google_compute_network.drip_nonprod.id
  region  = "us-central1"
}

# Cloud NATs
resource "google_compute_router_nat" "nonprod_nat" {
  name                               = "drip-nonprod-nat"
  router                             = google_compute_router.nonprod_router.name
  region                             = "us-central1"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_compute_router_nat" "prod_nat" {
  name                               = "drip-prod-nat"
  router                             = google_compute_router.prod_router.name
  region                             = "us-central1"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
```
# Key generation
Generate SSH Key Pair on Local Machine

Open your local terminal and run:
```
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```
#### Step 2.1: Copy the public key from local machine to public VM
```
scp ~/.ssh/id_rsa username@public-vm-externalip:~/id_rsa
```
#### Step 2.2: SSH into the public VM
```
ssh username@public_vm_ip
```
#### Step 2.3: From the public VM, copy the public key to the private VM
```
mkdir -p ~/.ssh
mv ~/id_rsa ~/.ssh/id_rsa
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa
```
#### from the public VM, run:
```
ssh -i ~/.ssh/id_rsa username@private_vm_ip
```
