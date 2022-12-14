#! /bin/bash
echo "***********************************************"
echo "Installing NGinx and removing default config"
echo "***********************************************"
sudo apt-get install -y nginx 
sudo rm /etc/nginx/sites-enabled/default
sudo rm /etc/nginx/sites-available/default

echo "***********************************************"
echo "Installing Certbot for managing SSL Certificate"
echo "***********************************************"
apt-get update 
sudo apt-get install certbot python3-certbot-nginx -y
#Setup dns and email.
sudo certbot certonly --agree-tos --email sample@sampel.com -d domain_name
#Run LS Command to see Certificate Directory
ls /etc/letsencrypt/live/*domain_name/

echo "*********************************"
echo "Setting up Nginx for Reverse Proxy"
echo "*********************************"
mkdir -p /var/www/html/example

cat <<EOT> /etc/nginx/sites-available/example.conf
server {
            listen 80;
            root /var/www/html/example;
            index index.php index.html;
            server_name example.com domain_name;

	    access_log /var/log/nginx/SUBDOMAIN.access.log;
    	    error_log /var/log/nginx/SUBDOMAIN.error.log;


        location / {
            # Return a 404 error for instances when the server receives 
						# requests for untraceable files and directories.
            try_files $uri $uri/ =404;
}

server {
        # Binds the TCP port 443 and enable SSL.
        listen 443 SSL;
	    # Root directory used to search for a file        
	    root /var/www/html/example; 
	    # Defines the domain or subdomain name. 
        # If no server_name is defined in a server block then 
	    # Nginx uses the 'empty' name
        server_name domain_name;

	    # Path of the SSL certificate
        ssl_certificate /etc/letsencrypt/live/domain_name/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/domain_name/privkey.pem;
	    # Use the file generated by certbot command.
        include /etc/letsencrypt/options-ssl-nginx.conf;
	    # Define the path of the dhparam.pem file.
        ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

        location / {
	      # Return a 404 error for instances when the server receives 
	      # requests for untraceable files and directories.
        try_files $uri $uri/ =404;
        }
}
EOT


sudo nginx -t
cd /etc/nginx/sites-enabled
ln -s ../sites-available/example.conf .
sudo service nginx reload
