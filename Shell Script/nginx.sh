echo "***********************************************"
echo "Installing NGinx and removing default config"
echo "***********************************************"
sudo apt-get install -y nginx 
sudo rm /etc/nginx/sites-enabled/default
sudo rm /etc/nginx/sites-available/default

echo "*********************************"
echo "Setting up Nginx for Reverse Proxy"
echo "*********************************"
mkdir -p /var/www/html/example

cat <<EOT> /etc/nginx/sites-available/example.conf
server {
            listen 80;
            root /var/www/html/example;
            index index.php index.html;
            server_name example.com www.example.com;

	    access_log /var/log/nginx/SUBDOMAIN.access.log;
    	    error_log /var/log/nginx/SUBDOMAIN.error.log;


        location / {
            # Return a 404 error for instances when the server receives 
						# requests for untraceable files and directories.
            try_files $uri $uri/ =404;
}
EOT

sudo nginx -t
cd /etc/nginx/sites-enabled
ln -s ../sites-available/example.conf .
sudo service nginx reload
