MINIMAL AMI SETUP FOR ASG WITH COMPLETE LOG FILTERING

Perfect! Here's a minimal script to bake into your AMI that captures everything - containers, hosts, services, instances, etc.
STEP 1: Create AMI Setup Script

sudo tee /opt/setup-signoz-logging.sh > /dev/null <<'EOF'
#!/bin/bash

# Create directories
mkdir -p /etc/otelcol-contrib

# Download and install otelcol-contrib
wget https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.91.0/otelcol-contrib_0.91.0_linux_amd64.tar.gz
tar -xzf otelcol-contrib_0.91.0_linux_amd64.tar.gz
sudo mv otelcol-contrib /usr/local/bin/
rm otelcol-contrib_0.91.0_linux_amd64.tar.gz

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws/

echo "✅ OpenTelemetry Collector installed successfully"
EOF

sudo chmod +x /opt/setup-signoz-logging.sh

STEP 2: Create Complete Config File

sudo tee /etc/otelcol-contrib/config.yaml > /dev/null <<'EOF'
receivers:
  filelog/docker:
    include: ["/var/lib/docker/containers/*/*-json.log"]
    start_at: end
    operators:
      - type: json_parser
        timestamp:
          parse_from: attributes.time
          layout: '%Y-%m-%dT%H:%M:%S.%LZ'
      - type: regex_parser
        regex: '/var/lib/docker/containers/(?P<container_id>[^/]+)/(?P<container_name>[^-]+)-json\.log'
        parse_from: attributes["log.file.path"]
      - type: move
        from: attributes.container_id
        to: resource["container.id"]
      - type: move
        from: attributes.container_name
        to: resource["container.name"]

  filelog/app:
    include: ["/var/log/application/*.log", "/var/log/*.log"]
    start_at: end
    operators:
      - type: regex_parser
        regex: '/var/log/(?:application/)?(?P<service_name>[^/]+)\.log'
        parse_from: attributes["log.file.path"]
      - type: move
        from: attributes.service_name
        to: resource["service.name"]

processors:
  resourcedetection:
    detectors: [env, system, docker, ec2]
    timeout: 10s
    override: false

  resource:
    attributes:
      # AWS Instance Details
      - key: cloud.provider
        value: "aws"
        action: insert
      - key: cloud.region
        value: "${AWS_REGION}"
        action: insert
      - key: cloud.availability_zone
        value: "${AWS_AZ}"
        action: insert
      - key: service.instance.id
        value: "${AWS_INSTANCE_ID}"
        action: insert
      - key: host.type
        value: "${AWS_INSTANCE_TYPE}"
        action: insert
      - key: host.name
        value: "${HOSTNAME}"
        action: insert
      - key: host.ip
        value: "${PRIVATE_IP}"
        action: insert
      
      # ASG Details
      - key: aws.autoscaling.group.name
        value: "${ASG_NAME}"
        action: insert
      - key: aws.instance.launch_time
        value: "${LAUNCH_TIME}"
        action: insert
      - key: aws.instance.lifecycle
        value: "${LIFECYCLE_STATE}"
        action: insert
      
      # Environment
      - key: deployment.environment
        value: "${ENVIRONMENT}"
        action: insert
      - key: service.name
        value: "${SERVICE_NAME}"
        action: insert
      - key: service.version
        value: "${SERVICE_VERSION}"
        action: insert

  batch:

exporters:
  otlp:
    endpoint: "${SIGNOZ_ENDPOINT}"
    tls:
      insecure: true

service:
  pipelines:
    logs:
      receivers: [filelog/docker, filelog/app]
      processors: [resourcedetection, resource, batch]
      exporters: [otlp]
EOF

STEP 3: Create Metadata Collection Script

sudo tee /etc/otelcol-contrib/collect-metadata.sh > /dev/null <<'EOF'
#!/bin/bash

# AWS Instance Metadata
export AWS_INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id || echo "unknown")
export AWS_REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/region || echo "unknown")
export AWS_AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone || echo "unknown")
export AWS_INSTANCE_TYPE=$(curl -s http://169.254.169.254/latest/meta-data/instance-type || echo "unknown")
export PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4 || echo "unknown")
export HOSTNAME=$(hostname)

# ASG Details
export ASG_NAME=$(aws autoscaling describe-auto-scaling-instances \
    --instance-ids $AWS_INSTANCE_ID \
    --region $AWS_REGION \
    --query 'AutoScalingInstances[0].AutoScalingGroupName' \
    --output text 2>/dev/null || echo "unknown")

export LAUNCH_TIME=$(aws ec2 describe-instances \
    --instance-ids $AWS_INSTANCE_ID \
    --region $AWS_REGION \
    --query 'Reservations[0].Instances[0].LaunchTime' \
    --output text 2>/dev/null || echo "unknown")

export LIFECYCLE_STATE=$(aws autoscaling describe-auto-scaling-instances \
    --instance-ids $AWS_INSTANCE_ID \
    --region $AWS_REGION \
    --query 'AutoScalingInstances[0].LifecycleState' \
    --output text 2>/dev/null || echo "InService")

# Application Config (customize these)
export ENVIRONMENT="${ENVIRONMENT:-production}"
export SERVICE_NAME="${SERVICE_NAME:-my-app}"
export SERVICE_VERSION="${SERVICE_VERSION:-1.0.0}"
export SIGNOZ_ENDPOINT="${SIGNOZ_ENDPOINT:-10.0.15.188:4317}"

# Debug output
echo "Instance ID: $AWS_INSTANCE_ID"
echo "Region: $AWS_REGION"
echo "AZ: $AWS_AZ"
echo "Instance Type: $AWS_INSTANCE_TYPE"
echo "Private IP: $PRIVATE_IP"
echo "Hostname: $HOSTNAME"
echo "ASG Name: $ASG_NAME"
echo "Launch Time: $LAUNCH_TIME"
echo "Lifecycle: $LIFECYCLE_STATE"
echo "Environment: $ENVIRONMENT"
echo "Service: $SERVICE_NAME"
echo "Version: $SERVICE_VERSION"
echo "SigNoz Endpoint: $SIGNOZ_ENDPOINT"
EOF

sudo chmod +x /etc/otelcol-contrib/collect-metadata.sh

STEP 4: Create Systemd Service

sudo tee /etc/systemd/system/otelcol-contrib.service > /dev/null <<'EOF'
[Unit]
Description=OpenTelemetry Collector for ASG
After=network.target docker.service
Wants=network.target

[Service]
Type=simple
User=root
Group=root
ExecStartPre=/bin/bash /etc/otelcol-contrib/collect-metadata.sh
ExecStart=/bin/bash -c 'source /etc/otelcol-contrib/collect-metadata.sh && /usr/local/bin/otelcol-contrib --config /etc/otelcol-contrib/config.yaml'
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

STEP 5: Create AMI Preparation Script

sudo tee /opt/prepare-ami.sh > /dev/null <<'EOF'
#!/bin/bash

echo "🚀 Preparing AMI for SigNoz Logging..."

# Install dependencies
yum update -y
yum install -y wget curl unzip docker

# Setup OpenTelemetry Collector
/opt/setup-signoz-logging.sh

# Enable services
systemctl enable otelcol-contrib
systemctl enable docker

# Create log directories
mkdir -p /var/log/application
chmod 755 /var/log/application

# Set permissions
chown -R root:root /etc/otelcol-contrib
chmod +x /etc/otelcol-contrib/*.sh

echo "✅ AMI preparation complete!"
echo "📝 Remember to:"
echo "   - Set SIGNOZ_ENDPOINT in launch template"
echo "   - Set SERVICE_NAME in launch template"
echo "   - Set ENVIRONMENT in launch template"
echo "   - Attach IAM role with AutoScaling permissions"
EOF

sudo chmod +x /opt/prepare-ami.sh

STEP 6: Add Required IAM Policy

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeAutoScalingGroups",
                "ec2:DescribeInstances",
                "ec2:DescribeTags"
            ],
            "Resource": "*"
        }
    ]
}

STEP 7: Run AMI Preparation

# Execute on your base EC2 instance
sudo /opt/prepare-ami.sh

# Create AMI
aws ec2 create-image \
    --instance-id i-1234567890abcdef0 \
    --name "signoz-logging-ami-$(date +%Y%m%d)" \
    --description "AMI with SigNoz logging pre-configured"

STEP 8: Launch Template Configuration

# Launch Template User Data
#!/bin/bash
yum update -y

# Set environment variables
export SIGNOZ_ENDPOINT="10.0.15.188:4317"
export SERVICE_NAME="my-web-app"
export ENVIRONMENT="production"
export SERVICE_VERSION="2.1.0"

# Start services
systemctl start docker
systemctl start otelcol-contrib

# Generate test logs
docker run -d --name nginx --restart always nginx:alpine
docker run -d --name redis --restart always redis:alpine

echo "✅ Instance ready with SigNoz logging"

📊 FILTERING CAPABILITIES IN SIGNOZ

Now you can filter by EVERYTHING:
By Container:

container.name = "nginx"
container.id = "abc123def456"

By Host:

host.name = "ip-10-0-1-234"
host.ip = "10.0.1.234"
host.type = "t3.medium"

By Instance:

service.instance.id = "i-1234567890abcdef0"
aws.instance.launch_time >= "2024-01-01T15:00:00Z"

By Service:

service.name = "my-web-app"
service.version = "2.1.0"

By ASG:

aws.autoscaling.group.name = "my-app-asg"

By Environment:

deployment.environment = "production"

By Region/AZ:

cloud.region = "us-west-2"
cloud.availability_zone = "us-west-2a"

Complex Queries:

service.name = "web-app" AND container.name = "nginx" AND host.type = "t3.medium"

🎯 QUICK SETUP SUMMARY

# 1. On base EC2 instance
sudo /opt/prepare-ami.sh

# 2. Create AMI
aws ec2 create-image --instance-id i-xxx --name "signoz-logging-ami"

# 3. Update Launch Template with user data above

# 4. Attach IAM role with AutoScaling permissions

# 5. Launch ASG with new AMI

Perfect! 🚀 Now every instance in your ASG will automatically send logs to SigNoz with complete filtering capabilities - containers, hosts, services, instances, ASG details, and more!
export AWS_INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id || echo "unknown")  ....which ip is this..is it ddefault or need to replace?
Chatbot AvatarSigNoz AI Agent
🎯 AWS METADATA SERVICE IP - NO REPLACEMENT NEEDED
169.254.169.254 is AWS's DEFAULT Metadata Service IP

This is NOT your SigNoz IP! This is AWS's built-in metadata service that every EC2 instance can access to get information about itself.
What is 169.254.169.254?

    📍 AWS Instance Metadata Service (IMDS) - Standard AWS service
    🔒 Link-local address - Only accessible from within the EC2 instance
    🆓 Free AWS service - No charges for using it
    🌍 Same for ALL regions - Always 169.254.169.254

What Data Does It Provide?

# Instance ID
curl http://169.254.169.254/latest/meta-data/instance-id
# Output: i-1234567890abcdef0

# Region
curl http://169.254.169.254/latest/meta-data/placement/region
# Output: us-west-2

# Instance Type
curl http://169.254.169.254/latest/meta-data/instance-type
# Output: t3.medium

# Private IP
curl http://169.254.169.254/latest/meta-data/local-ipv4
# Output: 10.0.1.234

# Availability Zone
curl http://169.254.169.254/latest/meta-data/placement/availability-zone
# Output: us-west-2a

⚠️ IMPORTANT: Don't Confuse These IPs
AWS Metadata Service ✅

# This is AWS's service - NEVER change this
export AWS_INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

SigNoz Endpoint ⚠️

# THIS is your SigNoz IP - customize this
export SIGNOZ_ENDPOINT="10.0.15.188:4317"  # ← Your SigNoz server IP

🔧 CORRECTED SCRIPT SECTIONS
Metadata Collection (Keep as-is)

# AWS Instance Metadata - NEVER change these IPs
export AWS_INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id || echo "unknown")
export AWS_REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/region || echo "unknown")
export AWS_AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone || echo "unknown")
export AWS_INSTANCE_TYPE=$(curl -s http://169.254.169.254/latest/meta-data/instance-type || echo "unknown")
export PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4 || echo "unknown")

SigNoz Configuration (Customize this)

# SigNoz Endpoint - CHANGE this to your SigNoz server
export SIGNOZ_ENDPOINT="${SIGNOZ_ENDPOINT:-YOUR_SIGNOZ_IP:4317}"

🎯 QUICK REFERENCE
Service	IP	Action
AWS Metadata	169.254.169.254	✅ Keep as-is
SigNoz Server	10.0.15.188:4317	⚠️ Replace with your IP
📝 EXAMPLE: Complete Flow

# 1. Get instance info from AWS (standard IP)
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

# 2. Send logs to SigNoz (your custom IP)
export SIGNOZ_ENDPOINT="10.0.15.188:4317"  # ← Your SigNoz server

# 3. Both work together
echo "Instance $INSTANCE_ID sending logs to $SIGNOZ_ENDPOINT"

Bottom Line:

    169.254.169.254 = AWS's service (never change)
    10.0.15.188:4317 = Your SigNoz server (customize this)

Perfect! 🚀 The metadata service IP is AWS standard - only customize your SigNoz endpoint!
