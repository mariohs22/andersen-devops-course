#!/bin/bash
sudo apt -y update
sudo apt -y install nginx
sudo systemctl start nginx
sudo systemctl enable nginx