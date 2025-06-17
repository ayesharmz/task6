#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras enable docker
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo docker pull shunnualisha8980/strapi-app:latest
sudo docker run -d -p 1337:1337 --name strapi-app shunnualisha8980/strapi-app:latest
