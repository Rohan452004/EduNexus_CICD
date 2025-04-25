#!/bin/bash
set -e

echo "Installing Node.js..."

# Update package lists
yum update -y

# Install the Node.js 16.x repository
curl -sL https://rpm.nodesource.com/setup_16.x | bash -

# Install Node.js and npm
yum install -y nodejs

# Create application directory if it doesn't exist
mkdir -p /var/www/edunexus

# Install PM2 globally
npm install -g pm2

# Check versions
echo "Node.js version:"
node -v
echo "npm version:"
npm -v
echo "PM2 version:"
pm2 -v

echo "Node.js installation completed"