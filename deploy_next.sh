#!/bin/bash
echo "Welcome to the next deploy script!"
echo "Installing Nginx..."
apt -y install nginx > /dev/null 2>/dev/null
echo "Installation complete!"
echo "Installing Node, NPM..."
curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash - > /dev/null 2>/dev/null
apt install -y nodejs npm > /dev/null 2>/dev/null
echo "Node, NPM installed!"
echo "Node version: $(node -v)"
echo "Installing PM2..."
npm install pm2 -g > /dev/null 2>/dev/null
echo "PM2 installed!"
read -p "Enter your project location: " project
cd "$project"
echo "Running pm2 process..."
pm2 start npm --name $(echo $project | sed -E 's/.*\/(.*)/\1/') -- start > /dev/null 2>/dev/null
echo "pm2 process running!"
echo "pm2 process list:"
pm2 list
read -p "Enter website domain: (Empty for none) " domain
echo "Generating Nginx config file..."
echo "
server {
        server_name $domain www.$domain;

        index index.html index.htm;
        root $project; #Make sure your using the full path

        # Serve any static assets with NGINX
        location /_next/static {
            alias $project/.next/static;
            add_header Cache-Control "public, max-age=3600, immutable";
        }

        location / {
            try_files \$uri.html \$uri/index.html # only serve html files from this dir
            @public
            @nextjs;
            add_header Cache-Control "public, max-age=3600";
        }

        location @public {
            add_header Cache-Control "public, max-age=3600";
        }

        location @nextjs {
            # reverse proxy for next server
            proxy_pass http://localhost:8080; 
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host $host;
            proxy_cache_bypass $http_upgrade;
        }

        listen 80 default_server;
        listen [::]:80;
}