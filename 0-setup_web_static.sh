#!/usr/bin/env bash
# web_static

sudo apt-get -y update
sudo apt-get -y upgrade
if sudo apt-get -y install nginx; then
    sudo mkdir -p /data/web_static/releases/test /data/web_static/shared
    echo "test 1234" | sudo tee /data/web_static/releases/test/index.html >/dev/null
    sudo ln -sf /data/web_static/releases/test/ /data/web_static/current
    sudo chown -hR ubuntu:ubuntu /data/

    sudo echo  -e "
http {
     include /etc/nginx/mime.types;
     default_type application/octet-stream;
     include /etc/nginx/conf.d/*.conf;
     include /etc/nginx/sites-enabled/*;
}
events {}
" | sudo tee /etc/nginx/nginx.conf > /dev/null
sudo echo  -e "
server {
       listen 80;
       location / {
       root /var/www/;
       index index.html;                                              
       }
}
" | sudo tee /etc/nginx/sites-available/default > /dev/null
sudo mkdir -p /var/www/
sudo echo "Hello World!" | sudo tee /var/www/index.html > /dev/null
sudo sed -i '6i\\tlocation /hbnb_static/ {\n\t\talias /data/web_static/current/;\n\t}\n' /etc/nginx/sites-available/default

sudo service nginx start
else
    echo "Failed to install Nginx."
    exit 1
fi



sudo sed -i "s/http {/http {\n\tadd_header X-Served-By $HOSTNAME;/" /etc/nginx/nginx.conf
sudo echo "Hello World!" | sudo tee /usr/share/nginx/html/index.html > /dev/null
sudo service nginx start
sudo service nginx restart
