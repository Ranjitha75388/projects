## FILE STRUCTURE
```
/project-root
│
├── EMS-ops/
│   ├── react-hooks-frontend/
│   └── springboot-backend/
│
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── terraform.tfvars        # empty if using GitLab variables
│   ├── outputs.tf
│   └── user-data/
│       ├── frontend-script.sh.tmpl
│       └── backend-script.sh.tmpl
│
├── install-docker.sh
├── docker-ami.pkr.hcl
├── .gitlab-ci.yml
```
1. .gitlab-ci.yml
```
stages:
  - build
  - pull
  - packer
  - deploy

variables:
  REGION: "us-east-1"
  FRONTEND_IMAGE: "$ECR_REGISTRY/frontend-repo"
  BACKEND_IMAGE: "$ECR_REGISTRY/backend-repo"
  DOCKER_HOST: "tcp://docker:2375"
  DOCKER_TLS_CERTDIR: ""

build_images:
  stage: build
  image: docker:24.0.7
  services:
    - docker:24.0.7-dind
  tags: [docker]
  before_script:
    - apk add --no-cache curl python3 py3-pip aws-cli
    - aws ecr get-login-password --region "$REGION" | docker login --username AWS --password-stdin "$ECR_REGISTRY"
  script:
    - docker build -t "$FRONTEND_IMAGE" ./EMS-ops/react-hooks-frontend
    - docker push "$FRONTEND_IMAGE"
    - docker build -t "$BACKEND_IMAGE" ./EMS-ops/springboot-backend
    - docker push "$BACKEND_IMAGE"

pull_and_run:
  stage: pull
  image: docker:20.10.16
  services:
    - docker:20.10.16-dind
  tags: [docker]
  before_script:
    - apk add --no-cache curl python3 py3-pip aws-cli
    - aws ecr get-login-password --region "$REGION" | docker login --username AWS --password-stdin "$ECR_REGISTRY"
  script:
    - docker pull "$FRONTEND_IMAGE"
    - docker pull "$BACKEND_IMAGE"
    - docker rm -f frontend-test || true
    - docker rm -f backend-test || true
    - docker run -d --name frontend-test -p 3000:3000 "$FRONTEND_IMAGE"
    - docker run -d --name backend-test \
        -e SPRING_DATASOURCE_URL="jdbc:mysql://${RDS_ENDPOINT}:3306/${DB_NAME}" \
        -e SPRING_DATASOURCE_USERNAME="$DB_USER" \
        -e SPRING_DATASOURCE_PASSWORD="$DB_PASS" \
        -e SPRING_JPA_HIBERNATE_DDL_AUTO="update" \
        -p 8081:8081 "$BACKEND_IMAGE"

build_ami:
  stage: packer
  image: ubuntu:20.04
  tags: [docker]
  before_script:
    - apt-get update && apt-get install -y curl unzip
    - curl -fsSL https://releases.hashicorp.com/packer/1.10.0/packer_1.10.0_linux_amd64.zip -o packer.zip
    - unzip packer.zip && mv packer /usr/local/bin/packer
  script:
    - packer init docker-ami.pkr.hcl
    - packer validate docker-ami.pkr.hcl
    - packer build docker-ami.pkr.hcl | tee build.log
    - AMI_ID=$(grep -o 'ami-[a-z0-9]\{17\}' build.log | tail -1)
    - echo "$AMI_ID" > terraform/latest_ami.txt
  artifacts:
    paths:
      - terraform/latest_ami.txt

terraform_apply:
  stage: deploy
  image: hashicorp/terraform:1.6.6
  tags: [docker]
  dependencies: [build_ami]
  before_script:
    - echo "$AWS_ACCESS_KEY_ID" > ~/.aws_access_key
    - echo "$AWS_SECRET_ACCESS_KEY" > ~/.aws_secret_key
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
2. docker-ami.pkr.hcl
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
  default = "us-east-1"
}

variable "instance_type" {
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

  provisioner "shell" {
    script = "install-docker.sh"
  }
}
```
3.install-docker.sh
```
#!/bin/bash
set -e

sudo apt-get update -y
sudo apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg \
  lsb-release \
  software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) stable"

sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo systemctl enable docker
docker --version
```
4. Terraform user-script.sh.tmpl for frontend
```
#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y awscli docker.io

aws configure set aws_access_key_id "${AWS_ACCESS_KEY_ID}"
aws configure set aws_secret_access_key "${AWS_SECRET_ACCESS_KEY}"
aws configure set default.region "${AWS_REGION}"

aws ecr get-login-password --region "${AWS_REGION}" | docker login --username AWS --password-stdin "${ECR_REGISTRY}"
docker pull "${ECR_REGISTRY}/frontend-repo"
docker run -d -p 3000:3000 "${ECR_REGISTRY}/frontend-repo"
```
5. Terraform backend-script.sh.tmpl
```
#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y awscli docker.io

aws configure set aws_access_key_id "${AWS_ACCESS_KEY_ID}"
aws configure set aws_secret_access_key "${AWS_SECRET_ACCESS_KEY}"
aws configure set default.region "${AWS_REGION}"

aws ecr get-login-password --region "${AWS_REGION}" | docker login --username AWS --password-stdin "${ECR_REGISTRY}"
docker pull "${ECR_REGISTRY}/backend-repo"

docker run -d \
  -e SPRING_DATASOURCE_URL="jdbc:mysql://${RDS_ENDPOINT}:3306/${DB_NAME}" \
  -e SPRING_DATASOURCE_USERNAME="${DB_USER}" \
  -e SPRING_DATASOURCE_PASSWORD="${DB_PASS}" \
  -e SPRING_JPA_HIBERNATE_DDL_AUTO="update" \
  -p 8081:8081 \
  "${ECR_REGISTRY}/backend-repo"
```
6.Terraform variables.tf
```
variable "region" { default = "us-east-1" }
variable "vpc_id" {}
variable "public_subnets" { type = list(string) }
variable "security_group_id" {}
variable "rds_endpoint" {}
variable "db_name" {}
variable "db_user" {}
variable "db_pass" {}
variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}
variable "ecr_registry" {}
```
7.Terraform outputs.tf
```
output "frontend_lb_dns" {
  description = "Frontend Load Balancer DNS"
  value       = aws_lb.frontend.dns_name
}

output "backend_lb_dns" {
  description = "Backend Load Balancer DNS"
  value       = aws_lb.frontend.dns_name
}

output "rds_endpoint" {
  value = aws_db_instance.mydb.endpoint
}
```
7.main.tf
```
provider "aws" {
  region     = var.region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

# Use the latest custom Docker AMI from Packer (can be passed from GitLab CI)
data "aws_ami" "latest_docker_ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["docker-engine-ubuntu-ami-*"]
  }
}

# Backend Launch Template
resource "aws_launch_template" "backend" {
  name_prefix   = "backend-lt"
  image_id      = data.aws_ami.latest_docker_ami.id
  instance_type = "t2.micro"
  key_name      = "ranjitha"

  user_data = base64encode(templatefile("${path.module}/user-data/backend-script.sh.tmpl", {
    AWS_ACCESS_KEY_ID     = var.aws_access_key_id,
    AWS_SECRET_ACCESS_KEY = var.aws_secret_access_key,
    AWS_REGION            = var.region,
    ECR_REGISTRY          = var.ecr_registry,
    RDS_ENDPOINT          = var.rds_endpoint,
    DB_NAME               = var.db_name,
    DB_USER               = var.db_user,
    DB_PASS               = var.db_pass
  }))

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.security_group_id]
  }
}

# Frontend Launch Template
resource "aws_launch_template" "frontend" {
  name_prefix   = "frontend-lt"
  image_id      = data.aws_ami.latest_docker_ami.id
  instance_type = "t2.micro"
  key_name      = "ranjitha"

  user_data = base64encode(templatefile("${path.module}/user-data/frontend-script.sh.tmpl", {
    AWS_ACCESS_KEY_ID     = var.aws_access_key_id,
    AWS_SECRET_ACCESS_KEY = var.aws_secret_access_key,
    AWS_REGION            = var.region,
    ECR_REGISTRY          = var.ecr_registry
  }))

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.security_group_id]
  }
}

# Frontend ALB
resource "aws_lb" "frontend" {
  name               = "frontend-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [var.security_group_id]
}

resource "aws_lb_target_group" "frontend" {
  name     = "frontend-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_lb.frontend.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}

resource "aws_autoscaling_group" "frontend" {
  name                      = "frontend-asg"
  max_size                  = 2
  min_size                  = 1
  desired_capacity          = 1
  vpc_zone_identifier       = var.public_subnets
  health_check_type         = "EC2"
  force_delete              = true

  launch_template {
    id      = aws_launch_template.frontend.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.frontend.arn]

  tag {
    key                 = "Name"
    value               = "frontend-instance"
    propagate_at_launch = true
  }
}

# Backend Target Group (reuses frontend ALB)
resource "aws_lb_target_group" "backend" {
  name     = "backend-tg"
  port     = 8081
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/actuator/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_listener_rule" "backend" {
  listener_arn = aws_lb_listener.frontend.arn
  priority     = 10

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
}

resource "aws_autoscaling_group" "backend" {
  name                      = "backend-asg"
  max_size                  = 2
  min_size                  = 1
  desired_capacity          = 1
  vpc_zone_identifier       = var.public_subnets
  health_check_type         = "EC2"
  force_delete              = true

  launch_template {
    id      = aws_launch_template.backend.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.backend.arn]

  tag {
    key                 = "Name"
    value               = "backend-instance"
    propagate_at_launch = true
  }
}

# (Optional) RDS MySQL (if not already created externally)
# resource "aws_db_instance" "mydb" {
#   identifier             = "ems-db"
#   allocated_storage      = 20
#   engine                 = "mysql"
#   engine_version         = "8.0"
#   instance_class         = "db.t3.micro"
#   name                   = var.db_name
#   username               = var.db_user
#   password               = var.db_pass
#   publicly_accessible    = true
#   vpc_security_group_ids = [var.security_group_id]
#   db_subnet_group_name   = aws_db_subnet_group.default.name
#   skip_final_snapshot    = true
# }

# output "rds_endpoint" {
#   value = aws_db_instance.mydb.endpoint
# }
```
#### GITLAB CI/CD VARIABLES (Set in UI)

Go to GitLab → Project → Settings → CI/CD → Variables and set:
```
| Key                     | Value                                         |
| ----------------------- | --------------------------------------------- |
| `AWS_ACCESS_KEY_ID`     | Your AWS Access Key ID                        |
| `AWS_SECRET_ACCESS_KEY` | Your AWS Secret Access Key                    |
| `ECR_REGISTRY`          | `xxxxxxxxxxx.dkr.ecr.us-east-1.amazonaws.com` |
| `RDS_ENDPOINT`          | `your-db.xxxxx.us-east-1.rds.amazonaws.com`   |
| `DB_NAME`               | `employees` or `ems`                          |
| `DB_USER`               | `admin`                                       |
| `DB_PASS`               | `admin12345678`                               |
```
#### FINAL STEP-BY-STEP DEPLOYMENT

    Push Code to GitLab – make sure .gitlab-ci.yml is at root.

    Configure Variables in GitLab UI.

    Runner picks up the pipeline.

    Build Docker images and push to ECR.

    Run tests by pulling and running containers locally (optional stage).

    Build AMI using Packer.

    Deploy Infrastructure with Terraform.

    Access your app using Load Balancer DNS from Terraform output.

