```
#!/bin/bash

# Variables
GIT_REPO="https://github.com/Ranjitha75388/ranjitha_assesment"          ### if public repo
# GIT_REPO="git@github.com:Ranjitha75388/ranjitha_assesment.git"        ### if private repo
APP_DIR="/home/ranjitha/ranjitha_assesment"
NODE_VERSION="18"

# Update system packages
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install Node.js and npm
echo "Installing Node.js and npm..."
curl -fsSL https://deb.nodesource.com/setup_$NODE_VERSION.x | sudo -E bash -
sudo apt -y install nodejs && npm
node  -v && npm -v

# Clone the frontend application from GitHub
echo "Cloning frontend repository..."
git clone --depth 1 $GIT_REPO $APP_DIR

# Navigate to application directory
cd $APP_DIR/ems-ops-phase/react-hooks-frontend

# Set Node.js options for OpenSSL (in case of legacy OpenSSL issues)
export NODE_OPTIONS=--openssl-legacy-provider

# Install dependencies
echo "Installing frontend dependencies..."
npm install

# Build the frontend 
echo "Building frontend..."
npm start

# echo "Frontend setup completed successfully!"
```
