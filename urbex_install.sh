#!/bin/bash

# ========================================
# Install python3.11
sudo apt-get install python3.11
sudo apt update
python3.11 -m pip install --upgrade pip
python3.11 -m pip install virtualenv

python3.11 -m venv venv
source venv/bin/activate

pip install -r requirements.txt

# ========================================
# install mysql
MYSQL_USER="urbex"
MYSQL_PASSWORD="@UrbexPAS1"
MYSQL_DATABASE="Urbex"
SQL_SCRIPT="database/database.sql"

sudo apt install mysql-server
sudo mysql < "database/init.sql"
mysql -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" -D"$MYSQL_DATABASE" < "$SQL_SCRIPT"
# =======================================
file_path="/etc/hosts"
line_to_search="127.0.5.5       urbex.com"

# Search for the line in the file
if grep -qF "$line_to_search" "$file_path"; then
    echo "Host already added."
else
    temp_file=$(mktemp)

    echo "$line_to_search" | cat - /etc/hosts > "$temp_file"

    sudo mv "$temp_file" /etc/hosts
fi
sudo systemctl restart mysql.service

# ==============================
# install php
sudo apt install apache2
sudo apt install php libapache2-mod-php php-mysql
sudo systemctl restart apache2

# =============================
# https
domain="Urbex"

config_file="/etc/apache2/sites-available/${domain}.conf"
if [ ! -f "$config_file" ]; then

    if [ ! -f "/etc/ssl/private/${domain}.key"]; then
        sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/${domain}.key -out /etc/ssl/certs/${domain}.crt
    else
        echo "Key already created."
    fi

    sudo mkdir /var/www/$domain
    sudo chmod 777 /var/www/$domain

    cat <<EOL | sudo tee /etc/apache2/sites-available/${domain}.conf

<VirtualHost *:443>
    ServerAdmin webmaster@${domain}
    ServerName ${domain}
    DocumentRoot /var/www/${domain}

    ErrorLog \${APACHE_LOG_DIR}/${domain}_error.log
    CustomLog \${APACHE_LOG_DIR}/${domain}_access.log combined

    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/${domain}.crt
    SSLCertificateKeyFile /etc/ssl/private/${domain}.key

    <Directory /var/www/${domain}>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOL

    # Enable the SSL module and the virtual host
    sudo a2enmod ssl
    sudo a2ensite ${domain}.conf

    # Restart Apache
    sudo systemctl restart apache2
else
    echo "Virtual host configuration file already exists for ${domain}. No changes made."
fi