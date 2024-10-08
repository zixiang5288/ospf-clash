# 这是一个基于OSPF路由协议的RouterOS分流方案 ( 支持 IPv6 )
### 特别感谢
> [孔昊天的折腾日记](https://www.youtube.com/@user-ek1qg7ti5r)  
> [allanchen2019](https://github.com/allanchen2019)  
> [dndx](https://github.com/dndx)  
> [Nathan](https://nathanyu.me/author/nathanyu/)
### 本文相关知识引用自
> [haotianlPM/rosrbgprouter](https://github.com/haotianlPM/rosrbgprouter)  
> [allanchen2019/ospf-over-wireguard](https://github.com/allanchen2019/ospf-over-wireguard)  
> [dndx/nchnroutes](https://github.com/dndx/nchnroutes)  
> [使用Clash在Debian系统上用TProxy模式搭建透明代理](https://nathanyu.me/clash-transparent-proxy-on-debian/)
---
# LXC 容器配置部分 ( N1 推荐系统为Armbian-bullseye-5.x内核 )
### 1. 模板下载
**https://github.com/Hamster-Prime/ospf-clash/releases/download/1.0.0/ubuntu-22.04.tar.zst**
### 2. 容器创建
取消"无特权容器"勾选
### 3. 容器完善
容器创建完成后，先不要开机，点击你创建的LXC容器-选项-功能，勾选以下选项
- 嵌套
- nfs
- smb
- fuse
### 4. 容器配置文件
进入PVE控制台，输入 `nano /etc/pve/lxc/"容器ID".conf` 修改配置文件，添加以下内容
```
lxc.apparmor.profile: unconfined
lxc.cgroup.devices.allow: a
lxc.cap.drop: 
lxc.cgroup2.devices.allow: c 10:200 rwm
lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file
```
启动容器并进入控制台
### 5. 安装 Clash 与 OSPF 服务
#### 选择喜欢的方式并根据脚本提示完成设置
```
wget https://raw.githubusercontent.com/Hamster-Prime/ospf-clash/main/install.sh && chmod +x install.sh && ./install.sh
```
# RouterOS 配置部分
### 1. 创建 Routing Table
```
/routing table add name=Clash_VPN fib
```
### 2. OSPF 设置
```
/routing ospf instance add name=Clash router-id="RouterOS的IPv4地址" routing-table=Clash_VPN
/routing ospf area add instance=Clash name=OSPF-Area-Clash
/routing ospf interface-template add area=OSPF-Area-Clash hello-interval=10s cost=10 priority=1 interfaces="LAN网桥名字或者网卡名字" type=broadcast
```
### 3. Firewall Mangle 设置
```
/ip firewall mangle add action=accept chain=prerouting src-address="安装Clash服务器的IPv4地址"
/ip firewall mangle add action=mark-routing new-routing-mark=Clash_VPN dst-address-type=!local chain=prerouting src-address-list=!No_Proxy
```
### 4. 跳过代理
```
/ip firewall address-list add address="不想代理的主机IP地址" list=No_Proxy
```
### 5. IPv6 设置 ( 可选 )
```
/routing rule add src-address=::/0 action=lookup-only-in-table table=main
```
```
/routing ospf instance add name=Clash_IPv6 version=3 router-id="RouterOS的IPv4地址" routing-table=Clash_VPN
/routing ospf area add instance=Clash_IPv6 name=OSPF-Area-Clash_IPv6
/routing ospf interface-template add area=OSPF-Area-Clash_IPv6 hello-interval=10s cost=10 priority=1 interfaces="LAN网桥名字或者网卡名字" type=broadcast
```
```
/ipv6 firewall mangle add action=accept chain=prerouting src-address="安装Clash服务器的本地IPv6地址"
/ipv6 firewall mangle add action=mark-routing new-routing-mark=Clash_VPN dst-address-type=!local chain=prerouting src-address-list=!No_Proxy
```
```
/ipv6 firewall address-list add address="不想代理的主机IP地址" list=No_Proxy
```
