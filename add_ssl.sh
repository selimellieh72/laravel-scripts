#!/bin/bash
echo "Welcome to the SSL script!"
echo "Installing snapd..."
sudo snap install core > /dev/null 2>/dev/null 
sudo snap refresh core > /dev/null 2>/dev/null
echo "Snapd installed!"
echo "Installing certbot..."
sudo snap install --classic certbot > /dev/null 2>/dev/null
echo "Certbot installed!"
echo "Enabling certbot..."
sudo ln -s /snap/bin/certbot /usr/bin/certbot
echo "Certbot enabled!"
echo "Running certbot..."
sudo certbot --nginx
echo "Certbot run!"
echo "SSL script complete!"