#!/bin/bash
echo "Welome to the next build script!"
echo "Installing nodejs, npm..."
curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash - > /dev/null 2>/dev/null
apt install -y nodejs npm > /dev/null 2>/dev/null
echo "Nodejs and npm installed!"
echo "Node version: $(node -v)"
read -p "Enter git repository URL: " repo
echo "Cloning repository..."
cd /var/www/html
git clone $repo > /dev/null 2>/dev/null
echo "Repository cloned!"
cd $(echo $repo | sed -E 's/.*\/(.*)/\1/')
echo "Installing dependencies..."
npm install --force
echo "Dependencies installed!"
echo "Building project..."
npx next build
echo "Project built!"