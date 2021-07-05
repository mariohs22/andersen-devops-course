#!/bin/bash
sudo amazon-linux-extras install nginx1 -y
sudo aws s3 cp s3://task6-http/index.html /usr/share/nginx/html/index.html
sudo systemctl start nginx
sudo systemctl enable nginx