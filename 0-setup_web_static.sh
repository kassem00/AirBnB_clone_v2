#!/usr/bin/env bash
# web static deploy
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install nginx
sudo mkdir -p /data/web_static/releases/test /data/web_static/shared
echo "This is a test" | sudo tee /data/web_static/releases/test/index.html > /dev/null
sudo ln -sf /data/web_static/releases/test/ /data/web_static/current
sudo chown -hR ubuntu:ubuntu /data/
sudo sed -i '/listen 80 default_server;/a \\tlocation /hbnb_static/ { alias /data/web_static/current/; }' /etc/nginx/sites-available/default
sudo sed -i "s/http {/http {\n\tadd_header X-Served-By \$HOSTNAME;/" /etc/nginx/nginx.conf
sudo service nginx restart
