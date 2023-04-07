#!/bin/bash

echo "Installing git, curl, php, mysql, composer, and laravel..."
apt install -y software-properties-common ca-certificates lsb-release apt-transport-https > /dev/null
echo "Installation complete!"
echo "Adding php repository..." 
LC_ALL=C.UTF-8 sudo add-apt-repository ppa:ondrej/php 
echo "Repository added!"
echo "Installing database dependencies..."
apt install -y mysql-server php-mysql php-dom > /dev/null
echo "Installation complete!"
cd /var/www/html
read -p "Enter your github project url: " url
git clone $url 
echo "Project cloned!
cd $(cat $url | sed -E 's/.*\/(.*)/\1/')
echo "Installing composer..."
wget -q -O composer-setup.php https://getcomposer.org/installer
php composer-setup.php --install-dir=/usr/local/bin --filename=composer > /dev/null
echo "Composer installed!"
echo "Installing project dependencies..."
composer install --ignore-platform-reqs > /dev/null
composer update --ignore-platform-reqs > /dev/null
echo "Dependencies installed!"
cp .env.example .env
echo "Please edit .env file"
vim .env
echo "Successfully edited .env file!"
echo "Generating key..."
php artisan key:generate
echo "Key generated!"