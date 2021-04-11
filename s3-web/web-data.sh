#!/bin/bash
sudo yum -y install httpd
sudo systemctl start httpd
sudo systemctl enable httpd
sudo chown -R ec2-user:ec2-user /var/www/html
echo "hello potato1" > /var/www/html/index.html
sudo su



sudo systemctl restart httpd