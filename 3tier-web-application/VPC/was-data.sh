#!/bin/bash

sudo su
sudo yum install -y java-1.8.0-openjdk.x86_64
sudo wget "https://downloads.apache.org/tomcat/tomcat-10/v10.0.4/bin/apache-tomcat-10.0.4.tar.gz"
sudo tar xzf apache-tomcat-10.0.4.tar.gz
cd apache-tomcat-10.0.4

echo "was potato1" > /apache-tomcat-10.0.4/webapps/ROOT/2.jsp

sudo ./bin/startup.sh