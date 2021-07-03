#!/bin/bash
apt-get update -y
apt install nginx -y
aws s3 cp s3://task6-http/index.html /var/www/html/index.nginx-debian.html
systemctl start nginx