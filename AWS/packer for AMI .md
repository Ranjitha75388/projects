# Packer
Packer is a popular open-source tool used to automate the creation of machine images, including Amazon Machine Images (AMIs) on AWS. It allows you to build customized AMIs from a single source configuration, which can be very useful for automating deployments and ensuring consistency across different environments

### Packer components
#### 1. Builders (Source Block)

- Defines where and how the machine image is built.

- Responsible for creating a virtual machine, booting it, and taking a snapshot.

- Examples:

  - amazon-ebs (for AWS EC2 AMIs)

  - docker (for Docker images)

  - googlecompute (for GCP)

  - azure-arm (for Azure)
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

#### 2.Provisioners(Build Block)

- Define how to install software or configure the instance after it boots.

  - Shell scripts (shell)

  -  Ansible, Chef, Puppet, etc.

  -  File uploads (file)
```
"provisioners": [
  {
    "type": "shell",
    "script": "install-docker.sh"
  }
]
```
#### 3.Post-Processors 

- Used for actions after image creation (optional).

   - Compress image

   - Upload to S3, GitHub

   - Register with a tool

   - Tag image

```
"post-processors": [
  {
    "type": "docker-tag",
    "repository": "mydocker/image",
    "tag": "latest"
  }
]
```

#### 4.Variables (variables.pkr.hcl)

- Reusable values to avoid hardcoding.
```
variable "region" {
  type    = string
  default = "us-east-1"
}
```

#### 5.User Variables (*.pkrvars.hcl)
- You can pass variables at runtime:
```
packer build -var "region=us-west-2" template.pkr.json
```
#### Additional Useful Files

- *.pkr.hcl or *.pkr.json: Main Packer config files(HCL is recommended as it supports better modularity, variable reusability, and plugin declarations.)

- install.sh, docker.sh, etc.: Provisioning shell scripts

### Packer Workflow to Build Docker-Enabled AMI

#### Step 1: Install Packer

Download from:https://developer.hashicorp.com/packer/install 

On Ubuntu:
```
sudo apt-get update && sudo apt-get install -y unzip
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install packer
```

#### Step 2: Set Up AWS IAM
1. Go to IAM > Roles in the AWS Console:

- Click Create role

- Choose Trusted entity type: AWS service

- Use case: EC2

- Click Next

2.Attach Required Policies

- Attach AmazonEC2FullAccess 
3.Attach Role to Your EC2 Instance

- Once the role is created:

- Go to your EC2 instance > Actions > Security > Modify IAM Role

- Choose the role you just created and attach it

#### Step 3:Create a Folder for Your Packer Build
```
mkdir packer-docker-ami
cd packer-docker-ami
```

#### Step 4:Create Shell Script: install-docker.sh
```
nano install-docker.sh
```
```
#!/bin/bash
set -e

echo "[+] Updating system..."
sudo apt update

echo "[+] Installing dependencies..."
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common gnupg

echo "[+] Creating Docker GPG keyring..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor | sudo tee /etc/apt/keyrings/docker.gpg > /dev/null

echo "[+] Adding Docker repo..."
echo \
  "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "[+] Updating apt index..."
sudo apt update

echo "[+] Installing Docker..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "[+] Enabling Docker service..."
sudo systemctl enable docker

echo "[+] Docker installed successfully!"
```
Make it executable:
```
chmod +x install-docker.sh
```
#### Step 5:Create Packer Template File:
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
#### Step 6:Build the AMI
```
packer init .
packer validate docker-ami.pkr.json
packer build docker-ami.pkr.json
```
After creating AMI Check in console new AMI is added.and EC2 instance created by packer script will be terminated.

#### Step 7:Create a Launch Template
ASG needs a Launch Template that tells AWS how to spin up instances.

1.Go to EC2 Console > Launch Templates.

2.Click “Create launch template”.

3.Fill in the following:

  - Name: docker-ami-template

  - AMI ID: Paste your custom AMI ID here (from Packer).

  - Instance Type: e.g., t3.micro

  - Key pair: Choose your existing key (for SSH access).

  - Security Group: Allow SSH (port 22), HTTP (port 80), or whatever you need.

  - IAM Role: If needed, attach one (e.g., for accessing S3 or ECR).

4.Click Create launch template.

#### Step 8: Create Auto Scaling Group (ASG)

1.Go to EC2 Console > Auto Scaling Groups.

2.Click “Create Auto Scaling group”.

3.Set:

  - Name: frontend-asg or backend-asg

  - Launch template: Select the one you just created.

  - VPC/Subnet: Choose the right VPC and public subnet(s).

  - Load Balancer: Choose exsitinng Load balancer and select it.

4.Set Group size:

 - Desired: 1

 - Min: 1

 - Max: 1 (or more, depending on your needs)

5.Click Create Auto Scaling Group.

#### Step:9 Check If Docker Is Installed in the EC2 Instance

1.Go to EC2 Console → Instances.

2.You’ll see the EC2 instance launched via ASG.

3.Connect via SSH:
```
ssh -i "ranjitha.pem" ubuntu@ec2-54-198-217-92.compute-1.amazonaws.com
```






packer

1.Download from: 


2.verify installation

![image](https://github.com/user-attachments/assets/5a902118-9591-455c-8f5b-b7ce2cb74230)


![image](https://github.com/user-attachments/assets/d57a29fd-aa36-4cfe-aec9-e1618079ee73)






ec2

![image](https://github.com/user-attachments/assets/8ff36081-5610-404c-942f-4b2f5980ba16)
