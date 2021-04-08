#!/bin/sh
yum update -y
yum install epel-release -y
yum install net-tools tcpdump nano -y
echo "toor" | sudo passwd root --stdin
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
setenforce 0
yum install openvpn iperf3 -y
cp /vagrant/files/server.conf /etc/openvpn/server.conf
cp /vagrant/files/mystatic.key /etc/openvpn/mystatic.key
systemctl start openvpn@server
systemctl enable openvpn@server
