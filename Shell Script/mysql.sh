#!/bin/bash
DBNAME=database_name
DBROOTPASSWORD=dbroot_pass
DBUSER=db_user
DBPASSWORD=db_pass

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