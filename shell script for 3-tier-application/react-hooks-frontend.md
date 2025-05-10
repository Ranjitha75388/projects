# Shell script for frontend application,cloning application code from private github repo,and running as a service

#### GIT_REPO="https://yourusername:yourPAT@github.com/yourusername/your-private-repo.git"

#### - To generate Personal Access Token(PAT) for accessing private repo through "https"

- Log in to your GitHub account.

- Click on your profile picture in the upper-right corner and select Settings.

-  In the left sidebar, click on Developer settings.

- Click on Personal access tokens, then select Tokens (classic).

- Click the Generate new token button.

- Provide a descriptive name for your token to remember its purpose.

- Expiration: Choose an expiration period for the token. 
    
-  Scopes: Select the appropriate scopes based on the access you need. For instance, to access repositories, select the **repo** scope.

-  After configuring the settings, click on Generate token.

-  Important: Copy and securely store your new token immediately, as it will only be displayed once.


```
#!/bin/bash

# Variables
GIT_REPO="https://Ranjitha75388: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@github.com/Ranjitha75388/ranjitha_assesment.git"
APP_DIR="/home/ranjitha/ranjitha_assesment"
NODE_VERSION="18"

# Update system packages
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install Node.js and npm
echo "Installing Node.js and npm..."
curl -fsSL https://deb.nodesource.com/setup_$NODE_VERSION.x | sudo -E bash -
sudo apt -y install nodejs
node -v && npm -v

# Clone the frontend application from GitHub
echo "Cloning frontend repository..."
git clone --depth 1 $GIT_REPO $APP_DIR

# Navigate to application directory
cd $APP_DIR/ems-ops-phase/react-hooks-frontend

# Set Node.js options for OpenSSL (in case of legacy OpenSSL issues)
export NODE_OPTIONS=--openssl-legacy-provider

# Remove cache
rm -rf node_modules package-lock.json

# Install dependencies
echo "Installing frontend dependencies..."
npm install

# Build the frontend
echo "Building frontend..."
npm start &

# Create a systemd service for the frontend
echo "Creating systemd service..."
SERVICE_FILE="/etc/systemd/system/frontend.service"

sudo bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=React Frontend Application
After=network.target

[Service]
ExecStart=/usr/bin/bash -c 'npm start'
WorkingDirectory=$APP_DIR/ems-ops-phase/react-hooks-frontend
Restart=always
RestartSec=5
User=ranjitha
Environment=NODE_OPTIONS=--openssl-legacy-provider
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=frontend-app

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and enable the service
sudo systemctl daemon-reload
sudo systemctl enable frontend.service
sudo systemctl start frontend.service

echo "Frontend setup completed successfully!"
echo "Check service status: sudo systemctl status frontend.service"
```
