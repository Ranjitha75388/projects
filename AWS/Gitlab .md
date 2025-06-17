





rails
![image](https://github.com/user-attachments/assets/feee3e1e-8a35-443a-8554-5bda7f3b0d51)




![image](https://github.com/user-attachments/assets/91754f25-f6b7-4ad3-bdb6-79fe960d7042)


After creating project
![image](https://github.com/user-attachments/assets/a1b16f2b-2c96-4235-9fd2-796494b41703)


ssh key
copy the ssh from local and paste it in gitlab ssh key


Check GitLab SSH Access
![image](https://github.com/user-attachments/assets/8e8b5514-14fe-46e7-9e64-54910ccd4d42)






Step-by-Step Beginner Guide (GitLab + AWS + Terraform)
✅ STEP 1: Setup GitLab.com

    Go to https://gitlab.com

    Create account (free)

    Click ➕ → "New project" → Blank project

    Project name: 3-tier-app

    Visibility: Private or Public → Create project

✅ STEP 2: Install Git and SSH

On your local system (Linux or Mac):

sudo apt update && sudo apt install git -y
ssh-keygen -t rsa -b 4096 -C "your-email@example.com"

Press Enter at every step. Then:

cat ~/.ssh/id_rsa.pub

Copy that key.
✅ STEP 3: Add SSH Key to GitLab

    Go to GitLab.com → Your Profile → Preferences

    Go to SSH Keys

    Paste your id_rsa.pub key

    Click "Add key"

✅ STEP 4: Clone the GitLab Repo

Back in your terminal:

git clone git@gitlab.com:your-username/3-tier-app.git
cd 3-tier-app













Step-by-Step: Create Access Key for Your IAM User

    Login to AWS Console at https://console.aws.amazon.com.

    Click on your username (top right corner) → Choose "Security credentials".

    Scroll down to Access keys.

    Click Create access key.

    You'll be asked for the use case:

        Choose: Command Line Interface (CLI) or Programmatic access.

        Click Next.

    You'll see your Access Key ID and Secret Access Key.

        Click Download .csv file to save them safely.

        Copy both values. These are needed for GitLab.

🚀 Next: Set Up in GitLab

In your GitLab project:

    Go to your repository.

    Click Settings → CI/CD → Expand Variables.

    Add these two protected variables:

        AWS_ACCESS_KEY_ID → your Access Key ID

        AWS_SECRET_ACCESS_KEY → your Secret Access Key

    ✅ Make sure to check "Protect variable" if you're using protected branches.
    ✅ Optionally check "Mask variable" for secrecy.



clone:
GIT_SSH_COMMAND="ssh -p 2222" git clone git@52.5.140.96:root/aws-terraform-infra.git

![image](https://github.com/user-attachments/assets/7cc63e80-5119-44c8-92e5-46bd2b994ff5)



![image](https://github.com/user-attachments/assets/ffa3f845-e78c-4b19-9961-8ce2499d19b4)

runner
![image](https://github.com/user-attachments/assets/5592b694-ae6b-4a3a-bc21-19166893ebb2)

token..expand 3 dots


![image](https://github.com/user-attachments/assets/e70f1880-c225-4667-8254-3360afbdc003)


-------------------------------------------------
--------------------------------------------------
```
nano .gitlab-ci.yml
```
```
stages:
  - pull
  - packer
  - deploy

variables:
  REGION: "us-east-1"
  ECR_REGISTRY: "179859935027.dkr.ecr.us-east-1.amazonaws.com"
  FRONTEND_IMAGE: "$ECR_REGISTRY/frontend-repo"
  BACKEND_IMAGE: "$ECR_REGISTRY/backend-repo"
  

#build_images:
#  stage: build
#  image: docker:24.0.7
#  services:
#    - name: docker:24.0.7
#      alias: docker
#  tags:
#    - docker
#  variables:
#    DOCKER_HOST: tcp://docker:2375/
#    DOCKER_TLS_CERTDIR: ""
#  before_script:
#    - apk add --no-cache curl python3 py3-pip aws-cli
#    - aws --version
#    - echo "Logging in to AWS ECR..."
#    - aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_REGISTRY
#  script:
#    - docker info
#    - echo "Building and pushing frontend image..."
#    - docker build -t $FRONTEND_IMAGE ./EMS-ops/react-hooks-frontend
#    - docker push $FRONTEND_IMAGE

#    - echo "Building and pushing backend image..."
#    - docker build -t $BACKEND_IMAGE ./EMS-ops/springboot-backend
#    - docker push $BACKEND_IMAGE

pull_and_run:
  stage: pull
  image: docker:20.10.16
  tags:
    - docker
  before_script:
    - apk add --no-cache curl python3 py3-pip aws-cli
    - aws --version
    - echo "Logging in to AWS ECR..."
    - aws ecr get-login-password --region "$REGION" | docker login --username AWS --password-stdin "$ECR_REGISTRY"
  script:
    - echo "Pulling image from ECR..."
    - docker pull "$FRONTEND_IMAGE"
    - docker pull "$BACKEND_IMAGE"
    - echo "Running container from image..."
    - docker run -d --name frontend-test -p 3000:3000 "$FRONTEND_IMAGE"
    - docker run -d --name backend-test \
        -e SPRING_DATASOURCE_URL="jdbc:mysql://$RDS_ENDPOINT:3306/employees" \
        -e SPRING_DATASOURCE_USERNAME="admin" \
        -e SPRING_DATASOURCE_PASSWORD="admin1234" \
        -e SPRING_JPA_HIBERNATE_DDL_AUTO="update" \
        -p 8081:8080 "$BACKEND_IMAGE"
build_ami:
  stage: packer
  image: ubuntu:20.04
  tags:
    - docker

  before_script:
    - apt-get update && apt-get install -y curl unzip gnupg software-properties-common
    # Install latest Packer >= 1.7 (with init support)
    - curl -fsSL https://releases.hashicorp.com/packer/1.10.0/packer_1.10.0_linux_amd64.zip -o packer.zip
    - unzip packer.zip && mv packer /usr/local/bin/packer
    - packer version

 script:
    - echo "Initializing Packer plugins"
    - packer init docker-ami.pkr.hcl
    - echo "Validating Packer template"
    - packer validate docker-ami.pkr.hcl
    - echo "Building Packer image"
    - packer build docker-ami.pkr.hcl | tee build.log
    - echo "Extracting AMI ID"
    - |
      AMI_ID=$(grep -o 'ami-[a-z0-9]\{17\}' build.log | tail -1)
      if [ -z "$AMI_ID" ]; then
        echo "❌ Failed to extract AMI ID"
        exit 1
      fi
      echo "✅ AMI_ID=$AMI_ID"
      mkdir -p terraform
      echo "$AMI_ID" > terraform/latest_ami.txt

  artifacts:
    paths:
      - terraform/latest_ami.txt

terraform_apply:
  stage: deploy
  image:
    name: hashicorp/terraform:1.6.6
    entrypoint: [""]
  tags:
    - docker
  dependencies:
    - build_ami
  before_script:
    - echo "Initializing Terraform"
  script:
    - cd terraform
    - terraform init
    - terraform apply -auto-approve
  artifacts:
    when: always
    paths:
      - terraform/
    exclude:
      - terraform/.terraform/**
      - terraform/terraform.tfplan
    expire_in: 1 hour

```

2.
```
nano docker-ami.pkr.hcl
```
```
packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.0.0"
    }
  }
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

source "amazon-ebs" "ubuntu" {
  region                        = var.aws_region
  instance_type                 = var.instance_type
  ami_name                      = "docker-engine-ubuntu-ami-{{timestamp}}"
  vpc_id                        = "vpc-0584a62b4c44dbfdc"
  subnet_id                     = "subnet-06091f820a40c616a"
  associate_public_ip_address   = true
  ssh_username                  = "ubuntu"

  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
    }
    owners      = ["099720109477"]
    most_recent = true
  }
}
build {
  name    = "docker-ami"
  sources = ["source.amazon-ebs.ubuntu"]

  # ✅ Provisioners go here, inside the build block
  provisioner "shell" {
    inline = [
      "echo 'Fixing apt issues with command-not-found'",
      "sudo rm -f /var/lib/apt/lists/lock",
      "sudo apt-get clean",
      "sudo apt-get update || true",
      "sudo apt-get remove -y command-not-found || true",
      "sudo apt-get update"
    ]
  }

  provisioner "shell" {
    script = "install-docker.sh"
  }
}
```
3.install docker.sh
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
4.terraform
```
nano main.tf
```
```
provider "aws" {
  region = var.region
}

resource "aws_launch_template" "frontend" {
  name_prefix   = "frontend-lt"
  image_id      = data.aws_ami.latest_docker_ami.id
  instance_type = "t2.micro"

  user_data = base64encode(file("${path.module}/user_data.sh"))

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [var.security_group_id]
  }
}

data "aws_ami" "latest_docker_ami" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "name"
    values = ["docker-engine-ubuntu-ami-*"]
  }
}

resource "aws_autoscaling_group" "frontend" {
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = var.public_subnets

  launch_template {
    id      = aws_launch_template.frontend.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.frontend.arn]
  health_check_type = "EC2"

  tag {
    key                 = "Name"
    value               = "frontend-instance"
    propagate_at_launch = true
  }
}
resource "aws_lb" "frontend" {
  name               = "frontend-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [var.security_group_id]
}

resource "aws_lb_target_group" "frontend" {
  name     = "frontend-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.frontend.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}

resource "aws_db_subnet_group" "public_subnet_group" {
  name       = "public-subnet-group"
  subnet_ids = var.public_subnets

  tags = {
    Name = "public-rds-subnet-group"
  }
}

resource "aws_db_instance" "mydb" {
  identifier              = "springboot-mysql"
  engine                  = "mysql"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_name                 = "employees"
  username                = "admin"
  password                = "admin1234"
  parameter_group_name    = "default.mysql8.0"
  db_subnet_group_name    = aws_db_subnet_group.public_subnet_group.name
  vpc_security_group_ids  = [var.security_group_id]
  skip_final_snapshot     = true
  publicly_accessible     = true
  deletion_protection     = false

  tags = {
    Name = "springboot-mysql"
  }
}

```
```
nano variable.tf
```
```
variable "region" {
  default = "us-east-1"
}

variable "vpc_id" {
  default = "vpc-0584a62b4c44dbfdc"
}

variable "public_subnets" {
  type    = list(string)
  default = [
    "subnet-06091f820a40c616a",
    "subnet-03837a37b0f0e85b3",
    "subnet-0cb1e3ba00a548229"
  ]
}

variable "security_group_id" {
  default = "sg-03fec65c1105ada94"
}
```
```
nano userdata.sh
```
```
#!/bin/bash

# Install AWS CLI
sudo apt-get update -y
sudo apt-get install -y awscli docker.io

# Configure AWS credentials manually
aws configure set aws_access_key_id AKIASTYD4Z4Z2K2Z5A2V
aws configure set aws_secret_access_key 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
aws configure set default.region us-east-1

# Authenticate to ECR and pull images
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 179859935027.dkr.ecr.us-east-1.amazonaws.com

docker pull 179859935027.dkr.ecr.us-east-1.amazonaws.com/frontend-repo
docker pull 179859935027.dkr.ecr.us-east-1.amazonaws.com/backend-repo

# Run containers
docker run -d -p 80:3000 179859935027.dkr.ecr.us-east-1.amazonaws.com/frontend-repo
docker run -d -p 8080:8080 179859935027.dkr.ecr.us-east-1.amazonaws.com/backend-repo

```
```
nano outputs.sh
```
```
output "load_balancer_dns" {
  value = aws_lb.frontend.dns_name
}


output "rds_endpoint" {
  value = aws_db_instance.mydb.endpoint
}

```
```
nano terraform.tfvars
```
```
region = "us-east-1"

```















install container

install runner

runner service
Fix: Install GitLab Runner service with a user

Run the following command to install it correctly:

sudo gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner

    If the user gitlab-runner doesn't exist, you can create it with:

sudo useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash

Then start the service:

sudo gitlab-runner start

Verify it’s running:

sudo systemctl status gitlab-runner




# ssh key

Step-by-step Solution:
1. ✅ Verify SSH Key is Loaded by the Agent

Check that your SSH private key is available to the SSH agent:

ssh-add -l

If it says “The agent has no identities,” then add your key:

ssh-add ~/.ssh/id_rsa

    Replace id_rsa with your actual private key file if different.

2. ✅ Confirm You're Using the Correct Key

Force Git to use the correct key and the right port (2222 in your case):

GIT_SSH_COMMAND="ssh -i ~/.ssh/id_rsa -p 2222" git clone git@52.5.140.96:root/sample-project.git

3. ✅ Check if the Public Key is Added to GitLab

In your GitLab UI (on port 8080):

    Go to top-right corner → User icon → Edit profile.

    Click SSH Keys.

    Make sure the exact public key (~/.ssh/id_rsa.pub) is pasted there.

    No extra whitespace or line breaks.

4. ✅ Test SSH Connection

Run:

ssh -i ~/.ssh/id_rsa -p 2222 git@52.5.140.96

If it connects and says something like:

Welcome to GitLab, @youruser!

Then you're good.

If not, the key is not recognized by GitLab.
5. ✅ Ensure Permissions Are Correct

Run:

chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub

🔄 If Nothing Works

Try debugging SSH with verbose mode:

ssh -v -i ~/.ssh/id_rsa -p 2222 git@52.5.140.96

This will show exactly what key is being offered and why it's failing.

Let me know what output you get from the debug command, and I’ll guide you further.
You said:
ubuntu@ip-10-0-15-188:~$ ssh-add -l
Could not open a connection to your authentication agent.
ubuntu@ip-10-0-15-188:~$ 
ChatGPT said:

You're seeing this error because the SSH agent isn't running, so it can't load your key into memory. Let's fix that first, then try the SSH access again.
✅ Step 1: Start the SSH Agent

Run:

eval "$(ssh-agent -s)"

You should see something like:

Agent pid 12345

✅ Step 2: Add Your Private Key to the Agent

Now add your SSH private key (replace with actual filename if not id_rsa):

ssh-add ~/.ssh/id_rsa

If successful, it will say:

Identity added: /home/ubuntu/.ssh/id_rsa

✅ Step 3: Confirm It's Loaded

ssh-add -l

You should now see your key listed.
✅ Step 4: Test SSH Connection to GitLab

Test the connection manually:

ssh -p 2222 git@52.5.140.96

You should see something like:

Welcome to GitLab, @yourusername!

✅ Step 5: Try Git Clone Again

git clone git@52.5.140.96:root/sample-project.git

Let me know the results of these steps, especially the output of step 4 (ssh -p 2222 git@...). If that still fails, we’ll dig into GitLab’s SSH configuration next.
You said:
ubuntu@ip-10-0-15-188:~$ ssh -p 2222 git@52.5.140.96
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Someone could be eavesdropping on you right now (man-in-the-middle attack)!
It is also possible that a host key has just been changed.
The fingerprint for the ED25519 key sent by the remote host is
SHA256:UO1M7QXLq4304mqAGa50Xr0fv9zszp7lueVLn4d7pmk.
Please contact your system administrator.
Add correct host key in /home/ubuntu/.ssh/known_hosts to get rid of this message.
Offending ECDSA key in /home/ubuntu/.ssh/known_hosts:5
  remove with:
  ssh-keygen -f '/home/ubuntu/.ssh/known_hosts' -R '[52.5.140.96]:2222'
Host key for [52.5.140.96]:2222 has changed and you have requested strict checking.
Host key verification failed.
ubuntu@ip-10-0-15-188:~$ git clone git@52.5.140.96:root/sample-project.git
Cloning into 'sample-project'...
git@52.5.140.96: Permission denied (publickey).
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
ubuntu@ip-10-0-15-188:~$ 
ChatGPT said:

You're now seeing two different issues, so let’s address them one by one:
⚠️ 1. SSH Host Key Changed Warning

This happens when the GitLab server's SSH key has changed (e.g., container recreated or new server), and your SSH client detects a mismatch to avoid a man-in-the-middle attack.
✅ Fix:

Run the command suggested in the error:

ssh-keygen -f "/home/ubuntu/.ssh/known_hosts" -R "[52.5.140.96]:2222"

Then retry the SSH connection:

ssh -p 2222 git@52.5.140.96

When prompted:

The authenticity of host '[52.5.140.96]:2222' can't be established.
...
Are you sure you want to continue connecting (yes/no)?

Type:

yes

That will add the new host key to your known_hosts.
❌ 2. Git Clone Still Fails With "Permission denied (publickey)"

This means GitLab isn't accepting your SSH key.
✅ Recheck These:

    Did you add the public key for the same user?

    You must add the public key (~/.ssh/id_rsa.pub) to your GitLab user profile:

        Go to http://52.5.140.96:8080/

        Sign in as the user you're cloning for (e.g., root)

        Navigate to:

User avatar (top right) → Edit Profile → SSH Keys

Paste the contents of:

    cat ~/.ssh/id_rsa.pub

Is your key agent running and loaded?

Verify with:

ssh-add -l

If it shows The agent has no identities, then re-run:

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

Use explicit command to test:

ssh -i ~/.ssh/id_rsa -p 2222 git@52.5.140.96

You should see:

Welcome to GitLab, @yourusername!

Try cloning with debug:

    GIT_SSH_COMMAND="ssh -v -i ~/.ssh/id_rsa -p 2222" git clone git@52.5.140.96:root/sample-project.git

    This will show where exactly the SSH handshake is failing.

✅ Summary of Commands You Should Run Now:

ssh-keygen -f "/home/ubuntu/.ssh/known_hosts" -R "[52.5.140.96]:2222"
ssh -p 2222 git@52.5.140.96       # Accept key
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
ssh -i ~/.ssh/id_rsa -p 2222 git@52.5.140.96

Then try cloning again:

GIT_SSH_COMMAND="ssh -i ~/.ssh/id_rsa -p 2222" git clone git@52.5.140.96:root/sample-project.git
