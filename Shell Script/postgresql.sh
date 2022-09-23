#!/bin/bash
DBNAME=database_name
DBROOTPASSWORD=dbroot_pass
DBUSER=db_user
DBPASSWORD=db_pass
sudo apt update
wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
sudo apt install postgresql postgresql-contrib -y
#sudo -u postgres psql -c "SELECT version();"
sudo systemctl enable postgresql.service
sudo systemctl start  postgresql.service
sudo echo "postgres:admin123" | chpasswd
runuser -l postgres -c "createuser $DBUSER"
sudo -i -u postgres psql -c "ALTER USER $DBUSER WITH ENCRYPTED PASSWORD '$DBPASSWORD';"
sudo -i -u postgres psql -c "CREATE DATABASE sonarqube OWNER $DBUSER;"
sudo -i -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $DBNAME to $DBUSER;"
systemctl restart  postgresql