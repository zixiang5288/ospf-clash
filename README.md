# LXC容器部分:

#### 推荐使用pve中的debian-11-standard_11.7-1_amd64.tar.zst模板

`wget https://raw.githubusercontent.com/Hamster-Prime/ospf-clash/main/installospfclash.sh && chmod +x installospfclash.sh && ./installospfclash.sh`

#### 根据脚本提示完成设置

# RouterOS设置部分:

#### OSPF设置

/routing ospf instance add name=dc1 router-id=10.0.1.1
