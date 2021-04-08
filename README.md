# otus_VPN

Первая часть ДЗ (tun и tap).

Статический ключ генерим командой openvpn --genkey --secret mystatic.key

На сервере:

```
[root@server ~]# systemctl status openvpn@server
● openvpn@server.service - OpenVPN Robust And Highly Flexible Tunneling Application On server
   Loaded: loaded (/usr/lib/systemd/system/openvpn@.service; enabled; vendor preset: disabled)
   Active: active (running) since Чт 2021-04-08 09:29:42 UTC; 4s ago
 Main PID: 13884 (openvpn)
   Status: "Pre-connection initialization successful"
   CGroup: /system.slice/system-openvpn.slice/openvpn@server.service
           └─13884 /usr/sbin/openvpn --cd /etc/openvpn/ --config server.conf

апр 08 09:29:42 server systemd[1]: Starting OpenVPN Robust And Highly Flexible Tunneling Application On server...
апр 08 09:29:42 server systemd[1]: Started OpenVPN Robust And Highly Flexible Tunneling Application On server.
[root@server ~]# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:4d:77:d3 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global noprefixroute dynamic eth0
       valid_lft 85411sec preferred_lft 85411sec
    inet6 fe80::5054:ff:fe4d:77d3/64 scope link 
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:26:b8:d3 brd ff:ff:ff:ff:ff:ff
    inet 192.168.10.10/24 brd 192.168.10.255 scope global noprefixroute eth1
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe26:b8d3/64 scope link 
       valid_lft forever preferred_lft forever
5: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UNKNOWN group default qlen 100
    link/none 
    inet 10.10.10.1/24 brd 10.10.10.255 scope global tun0
       valid_lft forever preferred_lft forever
    inet6 fe80::bb1e:9e34:30d7:a36c/64 scope link flags 800 
       valid_lft forever preferred_lft forever
[root@server ~]# ping 10.10.10.2
PING 10.10.10.2 (10.10.10.2) 56(84) bytes of data.
64 bytes from 10.10.10.2: icmp_seq=1 ttl=64 time=3.85 ms
64 bytes from 10.10.10.2: icmp_seq=2 ttl=64 time=2.46 ms
^C
--- 10.10.10.2 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 2.464/3.160/3.856/0.696 ms
[root@server ~]# 
```

На клиенте:

```
[root@client ~]# systemctl status openvpn@client
● openvpn@client.service - OpenVPN Robust And Highly Flexible Tunneling Application On client
   Loaded: loaded (/usr/lib/systemd/system/openvpn@.service; enabled; vendor preset: disabled)
   Active: active (running) since Чт 2021-04-08 09:30:24 UTC; 2min 51s ago
 Main PID: 13933 (openvpn)
   Status: "Initialization Sequence Completed"
   CGroup: /system.slice/system-openvpn.slice/openvpn@client.service
           └─13933 /usr/sbin/openvpn --cd /etc/openvpn/ --config client.conf

апр 08 09:30:24 client systemd[1]: Starting OpenVPN Robust And Highly Flexible Tunneling Application On client...
апр 08 09:30:24 client systemd[1]: Started OpenVPN Robust And Highly Flexible Tunneling Application On client.
[root@client ~]# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:4d:77:d3 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global noprefixroute dynamic eth0
       valid_lft 85542sec preferred_lft 85542sec
    inet6 fe80::5054:ff:fe4d:77d3/64 scope link 
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:61:30:51 brd ff:ff:ff:ff:ff:ff
    inet 192.168.10.20/24 brd 192.168.10.255 scope global noprefixroute eth1
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe61:3051/64 scope link 
       valid_lft forever preferred_lft forever
5: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UNKNOWN group default qlen 100
    link/none 
    inet 10.10.10.2/24 brd 10.10.10.255 scope global tun0
       valid_lft forever preferred_lft forever
    inet6 fe80::1601:6f68:f59c:912d/64 scope link flags 800 
       valid_lft forever preferred_lft forever
[root@client ~]# ping 10.10.10.1
PING 10.10.10.1 (10.10.10.1) 56(84) bytes of data.
64 bytes from 10.10.10.1: icmp_seq=1 ttl=64 time=3.66 ms
64 bytes from 10.10.10.1: icmp_seq=2 ttl=64 time=2.13 ms
64 bytes from 10.10.10.1: icmp_seq=3 ttl=64 time=2.15 ms
^C
--- 10.10.10.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2015ms
rtt min/avg/max/mdev = 2.134/2.653/3.669/0.718 ms
[root@client ~]# 
```

Меряем tun:

На сервере:

```
[root@server ~]# iperf3 -s
-----------------------------------------------------------
Server listening on 5201
-----------------------------------------------------------
Accepted connection from 10.10.10.2, port 45112
[  5] local 10.10.10.1 port 5201 connected to 10.10.10.2 port 45114
[ ID] Interval           Transfer     Bandwidth
[  5]   0.00-1.00   sec  14.9 MBytes   125 Mbits/sec                  
[  5]   1.00-2.00   sec  17.1 MBytes   143 Mbits/sec                  
[  5]   2.00-3.00   sec  17.2 MBytes   145 Mbits/sec                  
[  5]   3.00-4.00   sec  16.4 MBytes   138 Mbits/sec                  
[  5]   4.00-5.00   sec  17.3 MBytes   145 Mbits/sec                  
[  5]   5.00-6.00   sec  17.1 MBytes   144 Mbits/sec                  
[  5]   6.00-7.00   sec  17.9 MBytes   150 Mbits/sec                  
[  5]   7.00-8.00   sec  17.4 MBytes   146 Mbits/sec                  
[  5]   8.00-9.01   sec  17.9 MBytes   149 Mbits/sec                  
[  5]   9.01-10.00  sec  17.7 MBytes   150 Mbits/sec                  
[  5]  10.00-11.00  sec  18.4 MBytes   155 Mbits/sec                  
[  5]  11.00-12.00  sec  17.7 MBytes   148 Mbits/sec                  
[  5]  12.00-13.00  sec  18.2 MBytes   152 Mbits/sec                  
[  5]  13.00-14.00  sec  17.9 MBytes   150 Mbits/sec                  
[  5]  14.00-15.01  sec  17.1 MBytes   143 Mbits/sec                  
[  5]  15.01-16.01  sec  17.7 MBytes   148 Mbits/sec                  
[  5]  16.01-17.00  sec  17.9 MBytes   152 Mbits/sec                  
[  5]  17.00-18.00  sec  17.7 MBytes   148 Mbits/sec                  
[  5]  18.00-19.00  sec  17.5 MBytes   147 Mbits/sec                  
[  5]  19.00-20.00  sec  17.9 MBytes   150 Mbits/sec                  
[  5]  20.00-21.00  sec  17.6 MBytes   148 Mbits/sec                  
[  5]  21.00-22.00  sec  18.0 MBytes   151 Mbits/sec                  
[  5]  22.00-23.00  sec  18.7 MBytes   157 Mbits/sec                  
[  5]  23.00-24.00  sec  17.6 MBytes   147 Mbits/sec                  
[  5]  24.00-25.00  sec  17.9 MBytes   151 Mbits/sec                  
[  5]  25.00-26.00  sec  17.7 MBytes   149 Mbits/sec                  
[  5]  26.00-27.01  sec  17.7 MBytes   148 Mbits/sec                  
[  5]  27.01-28.00  sec  18.1 MBytes   152 Mbits/sec                  
[  5]  28.00-29.00  sec  18.1 MBytes   152 Mbits/sec                  
[  5]  29.00-30.00  sec  18.1 MBytes   152 Mbits/sec                  
[  5]  30.00-30.05  sec   585 KBytes  90.7 Mbits/sec                  
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth
[  5]   0.00-30.05  sec  0.00 Bytes  0.00 bits/sec                  sender
[  5]   0.00-30.05  sec   529 MBytes   148 Mbits/sec                  receiver
-----------------------------------------------------------
Server listening on 5201
-----------------------------------------------------------
^Ciperf3: interrupt - the server has terminated
[root@server ~]# 
```

На клиенте:

```
[root@client ~]# iperf3 -c 10.10.10.1 -t 30 -i 5
Connecting to host 10.10.10.1, port 5201
[  4] local 10.10.10.2 port 45114 connected to 10.10.10.1 port 5201
[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
[  4]   0.00-5.00   sec  84.2 MBytes   141 Mbits/sec   41    308 KBytes       
[  4]   5.00-10.00  sec  88.4 MBytes   148 Mbits/sec    5    325 KBytes       
[  4]  10.00-15.01  sec  89.4 MBytes   150 Mbits/sec  102    307 KBytes       
[  4]  15.01-20.00  sec  88.4 MBytes   149 Mbits/sec  149    242 KBytes       
[  4]  20.00-25.00  sec  90.1 MBytes   151 Mbits/sec    2    337 KBytes       
[  4]  25.00-30.00  sec  89.5 MBytes   150 Mbits/sec   15    353 KBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-30.00  sec   530 MBytes   148 Mbits/sec  314             sender
[  4]   0.00-30.00  sec   529 MBytes   148 Mbits/sec                  receiver

iperf Done.
[root@client ~]# 
```

Меняем с конфигах сервера и клиента tun на tap:

```
[root@server ~]# cat /etc/openvpn/server.conf 
dev tap
ifconfig 10.10.10.1 255.255.255.0
topology subnet
secret /etc/openvpn/static.key
comp-lzo
status /var/log/openvpn-status.log
log /var/log/openvpn.log
verb 3
[root@server ~]# 

[root@client ~]# cat /etc/openvpn/client.conf 
dev tap
remote 192.168.10.10
ifconfig 10.10.10.2 255.255.255.0
topology subnet
route 192.168.10.0 255.255.255.0
secret /etc/openvpn/static.key
comp-lzo
status /var/log/openvpn-status.log
log /var/log/openvpn.log
verb 3
[root@client ~]# 
```

На сервере:

```
[root@server ~]# iperf3 -s
-----------------------------------------------------------
Server listening on 5201
-----------------------------------------------------------
Accepted connection from 10.10.10.2, port 45116
[  5] local 10.10.10.1 port 5201 connected to 10.10.10.2 port 45118
[ ID] Interval           Transfer     Bandwidth
[  5]   0.00-1.01   sec  15.3 MBytes   127 Mbits/sec                  
[  5]   1.01-2.00   sec  15.7 MBytes   133 Mbits/sec                  
[  5]   2.00-3.00   sec  17.6 MBytes   147 Mbits/sec                  
[  5]   3.00-4.00   sec  17.2 MBytes   144 Mbits/sec                  
[  5]   4.00-5.01   sec  17.1 MBytes   142 Mbits/sec                  
[  5]   5.01-6.01   sec  17.0 MBytes   142 Mbits/sec                  
[  5]   6.01-7.00   sec  16.9 MBytes   142 Mbits/sec                  
[  5]   7.00-8.00   sec  18.0 MBytes   151 Mbits/sec                  
[  5]   8.00-9.01   sec  16.7 MBytes   139 Mbits/sec                  
[  5]   9.01-10.00  sec  15.9 MBytes   134 Mbits/sec                  
[  5]  10.00-11.00  sec  16.5 MBytes   139 Mbits/sec                  
[  5]  11.00-12.00  sec  17.1 MBytes   144 Mbits/sec                  
[  5]  12.00-13.00  sec  16.1 MBytes   135 Mbits/sec                  
[  5]  13.00-14.00  sec  15.6 MBytes   131 Mbits/sec                  
[  5]  14.00-15.00  sec  16.9 MBytes   142 Mbits/sec                  
[  5]  15.00-16.00  sec  16.3 MBytes   137 Mbits/sec                  
[  5]  16.00-17.00  sec  16.7 MBytes   140 Mbits/sec                  
[  5]  17.00-18.00  sec  16.5 MBytes   139 Mbits/sec                  
[  5]  18.00-19.01  sec  17.0 MBytes   142 Mbits/sec                  
[  5]  19.01-20.00  sec  16.5 MBytes   139 Mbits/sec                  
[  5]  20.00-21.00  sec  16.6 MBytes   139 Mbits/sec                  
[  5]  21.00-22.00  sec  16.0 MBytes   134 Mbits/sec                  
[  5]  22.00-23.01  sec  17.0 MBytes   141 Mbits/sec                  
[  5]  23.01-24.00  sec  15.5 MBytes   131 Mbits/sec                  
[  5]  24.00-25.00  sec  16.5 MBytes   139 Mbits/sec                  
[  5]  25.00-26.00  sec  16.5 MBytes   138 Mbits/sec                  
[  5]  26.00-27.00  sec  16.8 MBytes   141 Mbits/sec                  
[  5]  27.00-28.00  sec  15.6 MBytes   131 Mbits/sec                  
[  5]  28.00-29.00  sec  16.5 MBytes   138 Mbits/sec                  
[  5]  29.00-30.00  sec  15.9 MBytes   134 Mbits/sec                  
[  5]  30.00-30.07  sec  1.04 MBytes   130 Mbits/sec                  
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth
[  5]   0.00-30.07  sec  0.00 Bytes  0.00 bits/sec                  sender
[  5]   0.00-30.07  sec   496 MBytes   139 Mbits/sec                  receiver
-----------------------------------------------------------
Server listening on 5201
-----------------------------------------------------------
^Ciperf3: interrupt - the server has terminated
[root@server ~]# 
```

На клиенте:

```
[root@client ~]# iperf3 -c 10.10.10.1 -t 30 -i 5
Connecting to host 10.10.10.1, port 5201
[  4] local 10.10.10.2 port 45118 connected to 10.10.10.1 port 5201
[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
[  4]   0.00-5.01   sec  85.1 MBytes   143 Mbits/sec  189    208 KBytes       
[  4]   5.01-10.00  sec  83.9 MBytes   141 Mbits/sec  203    290 KBytes       
[  4]  10.00-15.00  sec  82.6 MBytes   139 Mbits/sec  133    288 KBytes       
[  4]  15.00-20.00  sec  83.1 MBytes   139 Mbits/sec   54    277 KBytes       
[  4]  20.00-25.01  sec  81.6 MBytes   137 Mbits/sec   14    337 KBytes       
[  4]  25.01-30.00  sec  81.1 MBytes   136 Mbits/sec  164    212 KBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-30.00  sec   497 MBytes   139 Mbits/sec  757             sender
[  4]   0.00-30.00  sec   496 MBytes   139 Mbits/sec                  receiver

iperf Done.
[root@client ~]# 
```

Разница в тесте неощутима, TAP даже помедленнее в тесте получилась :(.


