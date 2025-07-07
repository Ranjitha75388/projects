
### 1.Install packages
```
nano install.sh
```

```
#!/bin/bash
set -e

echo "[+] Updating system packages..."
sudo apt-get update -y

echo "[+] Installing base dependencies..."
sudo apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg \
  software-properties-common \
  lsb-release \
  uidmap \
  dbus-user-session \
  iptables \
  unzip \
  git
------------------
#  Install Docker
------------------
echo "[+] Adding Docker GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker.gpg

echo "[+] Adding Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "[+] Updating package list..."
sudo apt-get update -y

echo "[+] Installing packages..."
sudo apt-get install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin \
  docker-ce-rootless-extras \
  slirp4netns \
  pigz \
  libslirp0

echo "[+] Enabling Docker to start on boot..."
sudo systemctl enable docker
docker --version

----------------------
#  Install Fluent Bit 
----------------------
echo "[+] Installing Fluent Bit manually..."

# 1.Add the Fluent Bit repository:

 sudo wget -qO /etc/apt/keyrings/fluentbit.asc https://packages.fluentbit.io/fluentbit.key
 echo "deb [signed-by=/etc/apt/keyrings/fluentbit.asc] https://packages.fluentbit.io/ubuntu/$(lsb_release -sc) $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/fluentbit.list


# 2.Update the package lists:

 sudo apt update

# 3.Install Fluent Bit:

sudo apt install -y fluent-bit

# 4.Enable and start the Fluent Bit service

sudo systemctl enable fluent-bit
sudo systemctl start fluent-bit

# 5.Verify the installation:

/opt/fluent-bit/bin/fluent-bit --version
sudo service fluent-bit status

-------------------------------
# Install Java JDK (OpenJDK 17)
-------------------------------

echo "[+] Installing OpenJDK 17..."
sudo apt-get install -y openjdk-17-jdk

echo "[+] Verifying Java installation..."
java -version

-------------------------------
# Install Node Exporter (Official)
-------------------------------
echo "[+] Installing Prometheus Node Exporter..."

NODE_EXPORTER_VERSION="1.8.1"

sudo useradd --no-create-home --shell /bin/false node_exporter

cd /tmp
curl -LO https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
tar xvf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz

sudo cp node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64/node_exporter /usr/local/bin/
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter
rm -rf node_exporter-${NODE_EXPORTER_VERSION}*

# Create systemd service
sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<EOF
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=default.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter


```


### 2.docker-ami.pkr.hcl
```
packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.0.0"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  region                  = "us-east-1"
  instance_type           = "t2.medium"
  ssh_username            = "ubuntu"
  ami_name                = "ubuntu-docker-ami-{{timestamp}}"

  subnet_id               = "subnet-06091f820a40c616a"
  vpc_id                  = "vpc-0584a62b4c44dbfdc"
  associate_public_ip_address = true

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    owners      = ["099720109477"]
    most_recent = true
  }
}

build {
  name    = "docker-app-ami"
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "shell" {
    script = "install-docker.sh"
    execute_command = "sudo -E bash '{{ .Path }}'"
  }
}

```

### 3.Validate and build:
```
packer init .
packer validate docker-ami.pkr.hcl
packer build docker-ami.pkr.hcl
```
