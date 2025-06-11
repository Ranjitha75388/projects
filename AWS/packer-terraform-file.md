1.Correct Directory and File Structure
```
packer-docker-app/
├── docker-ami.pkr.json
├── install-docker.sh
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
```
2.Step-by-Step Files

1.Create install-docker.sh:
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
### 3.tf files
```
nano main.tf
```
```
provider "aws" {
  region = var.region
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "packer-vpc"
  }
}

# Subnet
resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.region}a"

  tags = {
    Name = "packer-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

# Route Table
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

# Route Table Association
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.rt.id
}

# Security Group
resource "aws_security_group" "ssh" {
  name        = "allow-ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Run packer to build the AMI
resource "null_resource" "packer_build" {
  provisioner "local-exec" {
    command = <<EOT
      packer build -var "region=${var.region}" \
                   -var "subnet_id=${element(data.aws_subnets.default.ids, 0)}" \
                   docker-ami.pkr.json
    EOT
  }
}

# Get the latest AMI built by Packer
data "aws_ami" "docker_ami" {
  depends_on = [null_resource.packer_build]

  most_recent = true
  filter {
    name   = "name"
    values = ["docker-engine-ubuntu-ami-*"]
  }

  owners = ["self"]
}

# Launch Template using that AMI
resource "aws_launch_template" "docker_lt" {
  name_prefix   = "docker-launch-template-"
  image_id      = data.aws_ami.docker_ami.id
  instance_type = "t2.micro"

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  network_interfaces {
    associate_public_ip_address = true
    subnet_id                   = element(data.aws_subnets.default.ids, 0)
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "docker-ec2"
    }
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "docker_asg" {
  desired_capacity     = 1
  max_size             = 2
  min_size             = 1
  vpc_zone_identifier  = data.aws_subnets.default.ids
  launch_template {
    id      = aws_launch_template.docker_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "docker-asg-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_launch_template.docker_lt]
}

```
```
variables.tf
```
```
variable "region" {
  description = "AWS region"
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM instance profile name attached to EC2"
  type        = string
}
```
```
terraform.tfvars
```
```
region               = "us-east-1"
iam_instance_profile = "EC2FullAccessRole"  # Replace with your IAM Role Name
```
```
outputs.tf
```
```
output "ami_id" {
  description = "AMI ID created by Packer"
  value       = data.aws_ami.docker_ami.id
}

output "asg_name" {
  description = "Auto Scaling Group Name"
  value       = aws_autoscaling_group.docker_asg.name
}
```
### 4.Deploy Everything
```
terraform init
terraform apply -var-file="terraform.tfvars" -auto-approve
```


