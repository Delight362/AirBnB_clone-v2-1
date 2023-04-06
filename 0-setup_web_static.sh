#!/usr/bin/env bash

# set the web server
apt update -y

command -v nginx > testfile.txt
file="testfile.txt"

if [ ! -s "$file" ]
then	
	apt install nginx -y
fi
rm $file

# create the necessary directories
mkdir -p /data/web_static/release/test
mkdir -p /data/web_static/shared

# create a fake HTML file for testing purposes
echo -e "<html>\n  <head>\n  </head>\n  <body>\n    Holberton School\n  </body>\n</html>" > /data/web_static/releases/test/index.html
ln -sf /data/web_static/release/test/ /data/web_static/current

# give ownership of the/data/ folder to the ubuntu user and group
chown -R ubuntu:ubuntu /data/
chgrp -R ubuntu /data/
printf %s "server {
    listen 80 default_server;
    listen [::]:80 default_server;
    add_header X-Served-By $HOSTNAME;
    root   /var/www/html;
    index  index.html index.htm;
    location /hbnb_static {
        alias /data/web_static/current;
        index index.html index.htm;
    }
    location /redirect_me {
        return 301 http://cuberule.com/;
    }
    error_page 404 /404.html;
    location /404 {
      root /var/www/html;
      internal;
    }
}" > /etc/nginx/sites-available/default

# restart nginx to apply the changes
service nginx restart
