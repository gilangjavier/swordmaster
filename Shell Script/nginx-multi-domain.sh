echo "***********************************************"
echo "Installing NGinx and removing default config"
echo "***********************************************"
sudo apt-get install -y nginx 
sudo rm /etc/nginx/sites-enabled/default
sudo rm /etc/nginx/sites-available/default

echo "*********************************"
echo "Setting up Nginx for Multi domain"
echo "*********************************"
mkdir -p /var/www/html/example1

cat <<EOT> /etc/nginx/sites-available/example1.conf
server {
            listen 80;
            root /var/www/html/example1;
            index index.html index.htm;
			# Defines the domain or subdomain name. 
            # If no server_name is defined in a server block then 
			# Nginx uses the 'empty' name
            server_name example.net;

        location / {
            # Return a 404 error for instances when the server receives 
						# requests for untraceable files and directories.
            try_files $uri $uri/ =404;
        }
}

cat <<EOT> /etc/nginx/sites-available/example2.conf
server {
            listen 80;
            root /var/www/html/example2;
            index index.html index.htm;
			# Defines the domain or subdomain name. 
            # If no server_name is defined in a server block then 
			# Nginx uses the 'empty' name
            server_name second.example.net;

        location / {
            # Return a 404 error for instances when the server receives 
						# requests for untraceable files and directories.
            try_files $uri $uri/ =404;
        }
}

cat <<EOT> /etc/nginx/sites-available/example3.conf
server {
            listen 80;
            root /var/www/html/example3;
            index index.html index.htm;
			# Defines the domain or subdomain name. 
            # If no server_name is defined in a server block then 
			# Nginx uses the 'empty' name
            server_name third.example.net;

        location / {
            # Return a 404 error for instances when the server receives 
						# requests for untraceable files and directories.
            try_files $uri $uri/ =404;
        }
}

EOT
echo "*********************************"
echo "Test Connection"
echo "*********************************"
sudo nginx -t
sudo ln -s /etc/nginx/sites-available/example1.conf /etc/nginx/sites-enabled/
sudo service nginx reload
