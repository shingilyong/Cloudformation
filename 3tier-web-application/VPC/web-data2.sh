#!/bin/bash
sudo yum -y install httpd
sudo systemctl start httpd
sudo systemctl enable httpd
sudo chown -R ec2-user:ec2-user /var/www/html
echo "hello potato1" > /var/www/html/index.html
sudo su

echo Include conf.modules.d/*.conf >> /etc/httpd/conf/httpd.conf
echo LoadModule proxy_connect_module modules/mod_proxy_connect.so >> /etc/httpd/conf/httpd.conf
echo LoadModule proxy_module modules/mod_proxy.so >> /etc/httpd/conf/httpd.conf
echo LoadModule proxy_http_modules modules/mod_proxy_http.so >> /etc/httpd/conf/httpd.conf
echo -e "<VirtualHost *:80>" >> /etc/httpd/conf/httpd.conf
echo -e "\t"ProxyRequests On >> /etc/httpd/conf/httpd.conf
echo -e "\t"ProxyPreserveHost On >> /etc/httpd/conf/httpd.conf
echo -e "\t"<Proxy *> >> /etc/httpd/conf/httpd.conf
echo -e "\t\t"Order deny,allow >> /etc/httpd/conf/httpd.conf
echo -e "\t\t"Allow from all >> /etc/httpd/conf/httpd.conf
echo -e "\t\t"SetEnv force-proxy-request-1.0.1 >> /etc/httpd/conf/httpd.conf
echo -e "\t\t"SetEnv proxy-nokeepalive 1 >> /etc/httpd/conf/httpd.conf
echo -e "\t\t"SetEnv proxy-initial-not-pooled 1 >> /etc/httpd/conf/httpd.conf
echo -e "\t"</Proxy> >> /etc/httpd/conf/httpd.conf
echo -e "\t"ProxyPass "/servlet/" "internal-terraform-inxternal-elb-507165040.ap-northeast-2.elb.amazonaws.com:8080/" ttl=60 >> /etc/httpd/conf/httpd.conf
echo -e "\t"ProxyPassMatch "^/.*\.(jsp|do)$" "internal-terraform-inxternal-elb-507165040.ap-northeast-2.elb.amazonaws.com:8080/" >> /etc/httpd/conf/httpd.conf
echo -e "\t"Timeout 120 >> /etc/httpd/conf/httpd.conf
echo "</VirtualHost>" >> /etc/httpd/conf/httpd.conf