#!/bin/bash
#centos7.4安装varnish脚本

chmod -R 777 /usr/local/src/
#1、时间时区同步，修改主机名
ntpdate cn.pool.ntp.org
hwclock --systohc
echo "*/30 * * * * root ntpdate -s 3.cn.poop.ntp.org" >> /etc/crontab

sed -i 's|SELINUX=.*|SELINUX=disabled|' /etc/selinux/config
sed -i 's|SELINUXTYPE=.*|#SELINUXTYPE=targeted|' /etc/selinux/config
sed -i 's|SELINUX=.*|SELINUX=disabled|' /etc/sysconfig/selinux 
sed -i 's|SELINUXTYPE=.*|#SELINUXTYPE=targeted|' /etc/sysconfig/selinux
setenforce 0 && systemctl stop firewalld && systemctl disable firewalld 

rm -rf /var/run/yum.pid 
rm -rf /var/run/yum.pid

wget https://packagecloud.io/install/repositories/varnishcache/varnish5/script.rpm.sh
sh script.rpm.sh
yum -y install varnish 
varnishd -V 
yum -y install httpd && systemctl start httpd 
echo "Hello Yang"> /var/www/html/index.html
sed -i 's|.port = "8080";|.port = "80";|' /etc/varnish/default.vcl
systemctl restart varnish

#打开浏览器http://192.168.127.66:6081/，如下图所示

#加速web服务器
#yum install httpd -y && systemctl start httpd
#echo "webserver hello Yang" > /var/www/html/index.html
#systemctl restart httpd
#vim /etc/varnish/varnish.params ---修改如下
#19 VARNISH_LISTEN_PORT=80 


#vim /etc/varnish/default.vcl
#16 backend web {
#17 .host = "192.168.127.170"; ---填写web服务器的地址
#18 .port = "80"; ---端口
#19 }

#systemctl restart varnish
#开始访问:varnish服务器的地址

curl -I 127.0.0.1 
