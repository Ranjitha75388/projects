# Packer
- Packer is an open-source tool developed by HashiCorp that automates the creation of machine images (like Amazon AMIs).
- It allows you to build customized AMIs from a single source configuration, which can be very useful for automating deployments and ensuring consistency across different environments

## Packer components overview

### 1. Builders (Source Block)

- Defines where and how the machine image is built.

- Responsible for creating a virtual machine, booting it, and taking a snapshot.

- Examples

  - amazon-ebs (for AWS EC2 AMIs)

  - docker (for Docker images)

  - googlecompute (for GCP)

  - azure-arm (for Azure)
 
#### Example (JSON format):
```
"builders": [
  {
    "type": "amazon-ebs",
    "region": "us-east-1",
    "source_ami": "ami-0c55b159cbfafe1f0",
    "instance_type": "t2.micro",
    "ssh_username": "ubuntu",
    "ami_name": "docker-ami-{{timestamp}}"
  }
]
```

### 2.Provisioners(Build Block)

- Define how to customize the instance (e.g., installing software).
- Types:
   - **shell**: Bash scripts
   - **ansible, puppet, chef**: Config management tools
   - **file**: Upload files

#### Example:
```
"provisioners": [
  {
    "type": "shell",
    "script": "install-docker.sh"
  }
]
```
### 3.Post-Processors 

- Define what to do after the image is built (e.g., compress, upload, tag).

#### Example:
```
"post-processors": [
  {
    "type": "docker-tag",
    "repository": "mydocker/image",
    "tag": "latest"
  }
]
```

### 4.Variables (variables.pkr.hcl)

- Avoid hardcoding values in your templates.

#### Example
```
variable "region" {
  type    = string
  default = "us-east-1"
}
```

### 5.User Variables (*.pkrvars.hcl)
- You can pass variables at runtime:

#### Example
```
packer build -var "region=us-west-2" template.pkr.json
```
#### File Formats in Packer
```
    File Name           Description                              

 `*.pkr.hcl`       ---   Main configuration file (recommended)    
 `*.pkrvars.hcl`   ---   Variable values at runtime              
 `*.json`          ---   Legacy template format (still supported) 
 `*.sh`            ---   Shell scripts used in provisioning phase 
```

## Step-by-Step Workflow to Create AMI

### Step 1: Install Packer

1.Download from:https://developer.hashicorp.com/packer/install 

On Ubuntu:
```
sudo apt-get update && sudo apt-get install -y unzip
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install packer
```
2.verify installation

![image](https://github.com/user-attachments/assets/5a902118-9591-455c-8f5b-b7ce2cb74230)

### Step 2: Set Up AWS IAM Role for EC2 (Packer Host)

1.Create a Role

 - Go to IAM > Roles > Create Role

 - Choose EC2 as the trusted entity

  - Attach policy: AmazonEC2FullAccess

2.Attach the Role to the EC2 Instance

- Go to EC2 > Instances

- Select your instance → Actions > Security > Modify IAM Role

- Attach the role created above

### Step 3:Prepare Directory Structure
```
mkdir packer-docker-ami
cd packer-docker-ami
```

### Step 4:Create Shell Script to Install Docker Engine

#### Create install-docker.sh:
```
nano install-docker.sh
```
#### Paste it
```
#!/bin/bash
set -e

echo "[+] Updating system packages..."
sudo apt-get update -y

echo "[+] Installing dependencies..."
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    software-properties-common \
    lsb-release

echo "[+] Adding Docker GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

echo "[+] Adding Docker repository..."
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) stable"

echo "[+] Installing Docker Engine..."
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

echo "[+] Enabling Docker on boot..."
sudo systemctl enable docker

echo "[+] Docker installation completed."
docker --version
```
#### Make it executable:
```
chmod +x install-docker.sh
```
### Step 5:Create Packer JSON Template
```
docker-ami.pkr.json
```
```
{
  "variables": {
    "aws_region": "us-east-1",
    "instance_type": "t2.micro",
    "ami_name": "docker-engine-ubuntu-ami-{{timestamp}}"
  },
  "builders": [
    {
      "type": "amazon-ebs",
      "region": "{{user `aws_region`}}",
      "instance_type": "{{user `instance_type`}}",
      "ami_name": "{{user `ami_name`}}",
      "source_ami_filter": {
        "filters": {
          "virtualization-type": "hvm",
          "name": "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*",
          "root-device-type": "ebs"
        },
        "owners": ["099720109477"],
        "most_recent": true
      },
      "ssh_username": "ubuntu",
      "vpc_id": "vpc-0584a62b4c44dbfdc",
      "subnet_id": "subnet-06091f820a40c616a",
      "associate_public_ip_address": true
    }
  ],
  "provisioners": [
    {
      "type": "shell",
      "script": "install-docker.sh"
    }
  ]
}
```
### Step 6:Validate and Build the Image
```
packer init .
packer validate docker-ami.pkr.json
packer build docker-ami.pkr.json
```
![image](https://github.com/user-attachments/assets/d57a29fd-aa36-4cfe-aec9-e1618079ee73)

**Output**: In **console** Packer will create an EC2 instance, run provisioning, then generate an AMI and terminate the EC2 instance.

- New AMI
![image](https://github.com/user-attachments/assets/6fa3ac58-10e8-422a-b8f1-51bfd8dc1394)

- EC2 Instance
![image](https://github.com/user-attachments/assets/afaa17a5-8473-4b5e-b8d6-2a330b233923)


## Post-AMI Creation Workflow


### Step 7:Create a Launch Template
ASG needs a Launch Template that tells AWS how to spin up instances.

1.Go to EC2 > Launch Templates

2.Click Create launch template

 - **Name**: docker-ami-template

 - **AMI ID**: (Paste from Packer output)

 - **Instance Type**: t2.micro

 - Key pair, IAM Role, and Security Groups as needed

### Step 8: Create Auto Scaling Group (ASG)

1.Go to EC2 > Auto Scaling Groups

2.Click Create Auto Scaling Group

 - Name: docker-asg

 - Select launch template created above.

 - Set min/max/desired capacity

 - Attach to excisting load balancer created previously.

#### Step:9 Check If Docker Is Installed in the EC2 Instance

1.Go to EC2 Console → Instances(launched by ASG)

![image](https://github.com/user-attachments/assets/757a1c41-d793-46ec-aa1f-f14c49193d43)

2.Connect via SSH:
```
ssh -i "ranjitha.pem" ubuntu@ec2-54-198-217-92.compute-1.amazonaws.com
```
![image](https://github.com/user-attachments/assets/8ff36081-5610-404c-942f-4b2f5980ba16)

#### Step 10:Access App via Load Balancer

![image](https://github.com/user-attachments/assets/aff4c8e5-1796-4bf9-ae1a-b069f74c7546)
