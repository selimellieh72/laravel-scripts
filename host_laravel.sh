#!/bin/bash
while [ $? -eq 0 ]; do
    echo "Welcome to the Laravel deploy script!"
    echo "Updating repositories..."
    apt -y update > /dev/null 2>/dev/null
    echo "Installing Nginx..."
    apt -y install nginx > /dev/null 2>/dev/null
    echo "Installation complete!"
    echo "Installing PHP-FPM..."
    apt -y install php-fpm > /dev/null 2>/dev/null
    echo "Installation complete!"
    echo -p "Enter your project location: " project
    echo -p "Enter website domain: (Empty for none) " domain
    echo "Generating Nginx config file..."
    echo "
    server {
    # Example PHP Nginx FPM config file
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name $domain www.$domain
    root $project/public;

    # Add index.php to setup Nginx, PHP & PHP-FPM config
    index index.php index.html index.htm index.nginx-debian.html;

    server_name _;

    location / {
        try_files \$uri \$uri/ =404;
    }

    # pass PHP scripts on Nginx to FastCGI (PHP-FPM) server
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;

        # Nginx php-fpm sock config:
        fastcgi_pass unix:/run/php/php8.1-fpm.sock;
        # Nginx php-cgi config :
        # Nginx PHP fastcgi_pass 127.0.0.1:9000;
    }

    # deny access to Apache .htaccess on Nginx with PHP, 
    # if Apache and Nginx document roots concur
    location ~ /\.ht {
        deny all;
    }
    } # End of PHP FPM Nginx config example
    " > /etc/nginx/sites-available/$domain
    echo "Nginx config file generated!"
    echo "Enabling Nginx config file..."
    ln -s /etc/nginx/sites-available/$domain /etc/nginx/sites-enabled/
    echo "Nginx config file enabled!"
    echo "Testing Nginx config file..."
    nginx -t
    echo "Restarting Nginx..."
    systemctl restart nginx
    echo "Nginx restarted!"
done
if [ $? -eq 0 ]; then
    echo "Laravel deploy complete!"
else
    echo "Laravel deploy failed!"
fi