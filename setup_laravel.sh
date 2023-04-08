#!/bin/bash
echo "Wellcome to the Laravel setup script!"

while [ $? -eq 0 ]; do
    echo "Updating packages..."
    apt update > /dev/null  2>/dev/null
    echo "Installing Core Dependencies..."
    apt install -y software-properties-common ca-certificates lsb-release apt-transport-https > /dev/null  2>/dev/null
    echo "Installation complete!"
    echo "Adding php repository..." 
    LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php > /dev/null  2>/dev/null
    echo "Repository added!"
    echo "Installing PHP..."
    apt install -y php php-dom > /dev/null 2>/dev/null
    echo "Installation complete!"
    cd /var/www/html
    read -p "Enter your github project url: " url
    git clone $url 
    echo "Project cloned!"
    cd $(echo $url | sed -E 's/.*\/(.*)/\1/')
    echo "Installing composer..."
    wget -q -O composer-setup.php https://getcomposer.org/installer
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer > /dev/null 2>/dev/null
    echo "Composer installed!"
    echo "Installing project dependencies..."
    composer install --ignore-platform-reqs > /dev/null 2>/dev/null
    composer update --ignore-platform-reqs > /dev/null  2>/dev/null
    echo "Dependencies installed!"
    cp .env.example .env > /dev/null 2>/dev/null
    echo "Please edit .env file"
    vim .env
    echo "Successfully edited .env file!"
    echo "Generating key..."
    php artisan key:generate
    echo "Key generated!"
    break
done

if [ $? -eq 0 ]; then
    echo "Laravel setup complete!"
else 
    echo "Laravel setup failed!"
fi