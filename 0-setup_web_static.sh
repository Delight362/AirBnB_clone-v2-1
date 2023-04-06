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
chown -R ubuntu:ubuntu /data
line="\\\tlocation /hbnb_static {\n\t\talias /data/web_static/current;\n\t}"
sed -i "60i $line" /etc/nginx/sites_enabled/default

# restart nginx to apply the changes
service nginx restart
