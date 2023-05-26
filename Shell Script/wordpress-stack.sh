#!/bin/bash
#Script for Automation Provisioning Wordpress, PHP8, MariaDB, and Nginx.
DBNAME=your_dbname
DBROOTPASSWORD=your_password
DBUSER=your_user
DBPASSWORD=your_password
SITENAME=wordpress/public_html

echo "*******************************"
echo "Provisioning VM Wordpress Stack(Wordpress, MySQL, NGINX) By Gilang Javier"
echo "*******************************"

echo "***********************"
echo "Add Repository for PHP8 and Updating apt sources"
echo "***********************"
sudo add-apt-repository ppa:ondrej/php -y
sudo apt-get install software-properties-common -y
sudo apt install zip unzip -y
sudo apt-get update

echo "***********************************************"
echo "Installing NGinx and removing default config"
echo "***********************************************"
sudo apt-get install -y nginx 
sudo rm /etc/nginx/sites-enabled/default
sudo rm /etc/nginx/sites-available/default

echo "********************************"
echo "Installing MariaDB for MySQL Server"
echo "********************************"

echo "mysql-server mysql-server/root_password password $DBROOTPASSWORD" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $DBROOTPASSWORD" | debconf-set-selections
sudo apt-get install -y mariadb-server
sudo mysql_install_db
# Emulate results of mysql_secure_installation, without using 'expect' to handle input
mysql --user=root --password=$DBROOTPASSWORD -e "UPDATE mysql.user SET Password=PASSWORD('$DBROOTPASSWORD') WHERE User='root'"
mysql --user=root --password=$DBROOTPASSWORD -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
mysql --user=root --password=$DBROOTPASSWORD -e "DELETE FROM mysql.user WHERE User=''"
mysql --user=root --password=$DBROOTPASSWORD -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
mysql --user=root --password=$DBROOTPASSWORD -e "FLUSH PRIVILEGES"


echo "********************************************************"
echo "Installing PHP"
echo "********************************************************"
sudo apt install php8.0-fpm php8.0-mysql php8.0-common php8.0-gmp php8.0-curl php8.0-intl php8.0-mbstring php8.0-xmlrpc php8.0-gd php8.0-xml php8.0-cli php8.0-zip -y
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/8.0/fpm/php.ini
sudo systemctl restart nginx.service
sudo systemctl restart php8.0-fpm.service

echo "************************************"
echo "Creating up database user for Wordpress"
echo "************************************"
mysql --user=root --password=$DBROOTPASSWORD -e "CREATE DATABASE $DBNAME;"
mysql --user=root --password=$DBROOTPASSWORD -e "CREATE USER $DBUSER@localhost IDENTIFIED BY '$DBPASSWORD';"
mysql --user=root --password=$DBROOTPASSWORD -e "GRANT ALL PRIVILEGES ON $DBNAME.* TO $DBUSER@localhost;"
mysql --user=root --password=$DBROOTPASSWORD -e "FLUSH PRIVILEGES;"


echo "*********************************"
echo "Setting up NGinx for Wordpress"
echo "*********************************"
mkdir -p /var/www/html/wordpress/public_html

cat <<EOT> /etc/nginx/sites-available/wordpress.conf
server {
            listen 80;
            root /var/www/html/wordpress/public_html;
            index index.php index.html;
            server_name trio.helloversepedia.tech;

	    access_log /var/log/nginx/SUBDOMAIN.access.log;
    	    error_log /var/log/nginx/SUBDOMAIN.error.log;


            location ~ \.php$ {
                         include snippets/fastcgi-php.conf;
                         fastcgi_pass unix:/run/php/php8.0-fpm.sock;
            }
}
EOT

sudo nginx -t
cd /etc/nginx/sites-enabled
ln -s ../sites-available/wordpress.conf .
sudo service nginx reload


echo "********************************************************"
echo "Downloading and installing Wordpress and dependencies..."
echo "********************************************************"
# Download and extract Wordpress, and delete archive
wget https://wordpress.org/latest.tar.gz -q -P /tmp
tar xzfC /tmp/latest.tar.gz /tmp
rm /tmp/latest.tar.gz

# Move Wordpress to Working Directory
SITEPATH=/var/www/html/$SITENAME
sudo mv /tmp/wordpress/* $SITEPATH
rm -r /tmp/wordpress

echo "***********************************************************"
echo "Setting up Wordpress configurations"
echo "***********************************************************"
# Setup Wordpress config file with database info
cp $SITEPATH/wp-config-sample.php  $SITEPATH/wp-config.php

# Setup file and directory permissions Wordpress
cd $SITEPATH
sudo chown -R www-data:www-data *
sudo chmod -R 755 *

sed -i "s/database_name_here/$DBNAME/"  /var/www/html/wordpress/public_html/wp-config.php
sed -i "s/username_here/$DBUSER/"       /var/www/html/wordpress/public_html/wp-config.php
sed -i "s/password_here/$DBPASSWORD/"   /var/www/html/wordpress/public_html/wp-config.php

# Add authentication salts from the Wordpress API for security
SALT=$(curl -L https://api.wordpress.org/secret-key/1.1/salt/)
STRING='put your unique phrase here'
printf '%s\n' "g/$STRING/d" a "$SALT" . w | ed -s $SITEPATH/wp-config.php

sudo service nginx reload
echo "**************************************************************"
echo "Success! Open link below to access website..."
echo "URL : trio.helloversepedia.tech"
echo "**************************************************************"