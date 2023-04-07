#!/bin/bash
while [ $? -eq 0 ]; do
    read -p "Enter project location " project
    echo "Updating repositories..."
    apt update > /dev/null  2>/dev/null
    echo "Installing MySQL..." 
    apt install -y mysql-server php-mysql > /dev/null 2>/dev/null
    systemctl start mysql.service > /dev/null 2>/dev/null
    echo "Installation complete!"
    read -p "Enter your database name: " dbname
    read -p "Enter your database username: " username
    read -p "Enter your database password: " password

    $username=$(printf '%q' "$username")
    password=$(printf '%q' "$password")
    echo "Creating user and granting privileges..."
    mysql -uroot -e "CREATE USER '$username'@'localhost' IDENTIFIED BY '$password';" > /dev/null 2>/dev/null
    mysql -uroot -e "CREATE DATABASE $dbname;" > /dev/null 2>/dev/null
    mysql -uroot -e "GRANT ALL PRIVILEGES ON $dbname.* TO '$username'@'localhost';" > /dev/null 2>/dev/null
    mysql -uroot -e "FLUSH PRIVILEGES;" > /dev/null 2>/dev/null
    echo "Database created!"
    echo "Updating project configuration..."
    cd "$project"
    sed -i "s/DB_CONNECTION=.*/DB_CONNECTION=mysql/" .env
    sed -i "s/DB_DATABASE=.*/DB_DATABASE=\"$dbname\"/" .env
    sed -i "s/DB_USERNAME=.*/DB_USERNAME=\"$username\"/" .env
    sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=\"$password\"/" .env
    echo "Configuration updated!"
    echo "Migrating database..."
    php artisan migrate
    break
done

if [ $? -eq 0 ]; then
    echo "Installation complete!"
else
    echo "Installation failed!"
fi