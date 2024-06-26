#!/bin/bash
while true; do
    echo "-------------------"
    echo "请选择要执行的操作:"
    echo "-------------------"
    echo ""
    echo "1. OSPF + Clash TUN"
    echo ""
    echo "2. OSPF + Clash TProxy"
    echo ""
    echo "3. EasyMosDNS"
    echo ""
    echo "4. 仅OSPF"
    echo ""
    echo "5. 退出"
    echo ""
    read -p "请输入操作编号： " option

    case "$option" in
        1)  wget https://raw.githubusercontent.com/Hamster-Prime/ospf-clash/main/install-ospf-clash_tun.sh && chmod +x install-ospf-clash_tun.sh && ./install-ospf-clash_tun.sh
            ;;
        2)  wget https://raw.githubusercontent.com/Hamster-Prime/ospf-clash/main/install-ospf-clash_tproxy.sh && chmod +x install-ospf-clash_tproxy.sh && ./install-ospf-clash_tproxy.sh
            ;;
        3)  wget https://raw.githubusercontent.com/Hamster-Prime/ospf-clash/main/install-easymosdns.sh && chmod +x install-easymosdns.sh && ./install-easymosdns.sh
            ;;
        4)  wget https://raw.githubusercontent.com/Hamster-Prime/ospf-clash/main/install-ospf.sh && chmod +x install-ospf.sh && ./install-ospf.sh
            exit 0
            ;;
        5)  echo "退出脚本"
            exit 0
            ;;
        *)  echo "无效选项，请重新选择"
            continue
            ;;
    esac
done
