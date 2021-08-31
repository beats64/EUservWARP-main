#!/usr/bin/env bash
export PATH=$PATH:/usr/local/bin

red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}
green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
yellow(){
    echo -e "\033[33m\033[01m$1\033[0m"
}
blue(){
    echo -e "\033[36m\033[01m$1\033[0m"
}
white(){
    echo -e "\033[1;37m\033[01m$1\033[0m"
}

bblue(){
    echo -e "\033[1;34m\033[01m$1\033[0m"
}

rred(){
    echo -e "\033[1;35m\033[01m$1\033[0m"
}


	if [[ -f /etc/redhat-release ]]; then
		release="Centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="Debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="Ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="Centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="Debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="Ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="Centos"
    fi

if [ $release = "Centos" ]
	then
            red " 不支持Centos系统，请更换Debian或Ubuntu "
      exit 1
	   fi
 
	if ! type curl >/dev/null 2>&1; then
	   yellow "curl 未安装，安装中 "
           apt update && apt install curl -y 
           else
           green "curl 已安装，继续 "
fi

        if ! type wget >/dev/null 2>&1; then
           yellow "wget 未安装 安装中 "
           apt update && apt install wget -y 
           else
           green "wget 已安装，继续 "
fi  
	   
bit=`uname -m`
version=`uname -r | awk -F "-" '{print $1}'`
main=`uname  -r | awk -F . '{print $1 }'`
minor=`uname -r | awk -F . '{print $2}'`
rv4=`ip a | grep global | awk 'NR==1 {print $2}' | cut -d'/' -f1`
rv6=`ip a | grep inet6 | awk 'NR==2 {print $2}' | cut -d'/' -f1`
op=`hostnamectl | grep -i Operating | awk -F ':' '{print $2}'`
vi=`hostnamectl | grep -i Virtualization | awk -F ':' '{print $2}'`


yellow " VPS相关信息如下："
    white "------------------------------------------"
    blue " 操作系统名称 -$op "
    blue " 系统内核版本 - $version " 
    blue " CPU架构名称  - $bit "
    blue " 虚拟架构类型 -$vi "
    white " -----------------------------------------------" 
sleep 1s

warpwg=$(systemctl is-active wg-quick@wgcf)
case ${warpwg} in
active)
     WireGuardStatus=$(green "运行中")
     ;;
*)
     WireGuardStatus=$(red "未运行")
esac


v44=`ping ipv4.google.com -c 1 | grep received | awk 'NR==1 {print $4}'`

if [[ ${v44} == "1" ]]; then
 v4=`wget -qO- -4 ip.gs` 
 WARPIPv4Status=$(curl -s4 https://www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2) 
 case ${WARPIPv4Status} in 
 on) 
 WARPIPv4Status=$(green "WARP已开启,当前IPV4地址：$v4 ") 
 ;; 
 off) 
 WARPIPv4Status=$(yellow "WARP未开启，当前IPV4地址：$v4 ") 
 esac 
else
WARPIPv4Status=$(red "不存在IPV4地址 ")

 fi 

v66=`ping ipv6.google.com -c 1 | grep received | awk 'NR==1 {print $4}'`

if [[ ${v66} == "1" ]]; then
 v6=`wget -qO- -6 ip.gs` 
 WARPIPv6Status=$(curl -s6 https://www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2) 
 case ${WARPIPv6Status} in 
 on) 
 WARPIPv6Status=$(green "WARP已开启,当前IPV6地址：$v6 ") 
 ;; 
 off) 
 WARPIPv6Status=$(yellow "WARP未开启，当前IPV6地址：$v6 ") 
 esac 
else
WARPIPv6Status=$(red "不存在IPV6地址 ")

 fi 
 
Print_ALL_Status_menu() {
blue "-----------------------"
blue "WGCF 运行状态\t: ${WireGuardStatus}"
blue "IPv4 网络状态\t: ${WARPIPv4Status}"
blue "IPv6 网络状态\t: ${WARPIPv6Status}"
blue "-----------------------"
}

if [[ ${vi} == " lxc" ]]; then
green " ---VPS扫描中---> "

elif [[ ${vi} == " OpenVZ" ]]; then
green " ---VPS扫描中---> "

else
yellow " 虚拟架构类型 - $vi "
yellow " 对此vps架构不支持，脚本安装自动退出，赶紧提醒甬哥加上你的架构吧！"
exit 1
fi

if [[ ${bit} == "x86_64" ]]; then

function w64(){

	if [ $release = "Debian" ]
	then
		apt install sudo -y && apt install curl sudo lsb-release iptables -y
                echo "deb http://deb.debian.org/debian $(lsb_release -sc)-backports main" | sudo tee /etc/apt/sources.list.d/backports.list
                apt update -y
                apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
	elif [ $release = "Ubuntu" ]
	then
		apt-get update -y &&  apt install sudo -y
		apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
	fi
wget -N -6 https://cdn.jsdelivr.net/gh/ygkkk/EUservWARP/wgcf -O /usr/local/bin/wgcf
wget -N -6 https://cdn.jsdelivr.net/gh/ygkkk/EUservWARP/wireguard-go -O /usr/bin/wireguard-go
chmod +x /usr/local/bin/wgcf
chmod +x /usr/bin/wireguard-go
echo | wgcf register
until [ $? -eq 0 ]
do
sleep 1s
echo | wgcf register
done
wgcf generate
sed -i 's/engage.cloudflareclient.com/2606:4700:d0::a29f:c001/g' wgcf-profile.conf
sed -i '/\:\:\/0/d' wgcf-profile.conf
sed -i 's/1.1.1.1/8.8.8.8,2001:4860:4860::8888/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f wgcf* wireguard-go*
grep -qE '^[ ]*precedence[ ]*::ffff:0:0/96[ ]*100' /etc/gai.conf || echo 'precedence ::ffff:0:0/96  100' | sudo tee -a /etc/gai.conf
yellow " 检测是否成功启动Warp！\n 显示IPV4地址：$(wget -qO- -4 ip.gs) "
green " 如上方显示IPV4地址：8.…………，则说明成功啦！\n 如上方无IP显示，则说明失败喽！！"
}

function w646(){
	    
	if [ $release = "Debian" ]
	then
		apt install sudo -y && apt install curl sudo lsb-release iptables -y
                echo "deb http://deb.debian.org/debian $(lsb_release -sc)-backports main" | sudo tee /etc/apt/sources.list.d/backports.list
                apt update -y
                apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
	elif [ $release = "Ubuntu" ]
	then
		apt-get update -y &&  apt install sudo -y
		apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
	fi
wget -N -6 https://cdn.jsdelivr.net/gh/ygkkk/EUservWARP/wgcf -O /usr/local/bin/wgcf
wget -N -6 https://cdn.jsdelivr.net/gh/ygkkk/EUservWARP/wireguard-go -O /usr/bin/wireguard-go
chmod +x /usr/local/bin/wgcf
chmod +x /usr/bin/wireguard-go
echo | wgcf register
until [ $? -eq 0 ]
do
sleep 1s
echo | wgcf register
done
wgcf generate
sed -i "5 s/^/PostUp = ip -6 rule add from $rv6 table main\n/" wgcf-profile.conf
sed -i "6 s/^/PostDown = ip -6 rule delete from $rv6 table main\n/" wgcf-profile.conf
sed -i 's/engage.cloudflareclient.com/2606:4700:d0::a29f:c001/g' wgcf-profile.conf
sed -i 's/1.1.1.1/8.8.8.8,2001:4860:4860::8888/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f wgcf* wireguard-go*
grep -qE '^[ ]*precedence[ ]*::ffff:0:0/96[ ]*100' /etc/gai.conf || echo 'precedence ::ffff:0:0/96  100' | sudo tee -a /etc/gai.conf
yellow " 检测是否成功启动（IPV4+IPV6）双栈Warp！\n 显示IPV4地址：$(wget -qO- -4 ip.gs) 显示IPV6地址：$(wget -qO- -6 ip.gs) "
green " 如上方显示IPV4地址：8.…………，IPV6地址：2a09:…………，则说明成功啦！\n 如上方IPV4无IP显示，IPV6显示本地IP，则说明失败喽！"
}

function w66(){

	if [ $release = "Debian" ]
	then
		apt install sudo -y && apt install curl sudo lsb-release iptables -y
                echo "deb http://deb.debian.org/debian $(lsb_release -sc)-backports main" | sudo tee /etc/apt/sources.list.d/backports.list
                apt update -y
                apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
	elif [ $release = "Ubuntu" ]
	then
		apt-get update -y &&  apt install sudo -y
		apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
	fi
wget -N -6 https://cdn.jsdelivr.net/gh/ygkkk/EUservWARP/wgcf -O /usr/local/bin/wgcf
wget -N -6 https://cdn.jsdelivr.net/gh/ygkkk/EUservWARP/wireguard-go -O /usr/bin/wireguard-go
chmod +x /usr/local/bin/wgcf
chmod +x /usr/bin/wireguard-go
echo | wgcf register
until [ $? -eq 0 ]
do
sleep 1s
echo | wgcf register
done
wgcf generate
sed -i "5 s/^/PostUp = ip -6 rule add from $rv6 table main\n/" wgcf-profile.conf
sed -i "6 s/^/PostDown = ip -6 rule delete from $rv6 table main\n/" wgcf-profile.conf
sed -i 's/engage.cloudflareclient.com/2606:4700:d0::a29f:c001/g' wgcf-profile.conf
sed -i '/0\.0\.0\.0\/0/d' wgcf-profile.conf
sed -i 's/1.1.1.1/2001:4860:4860::8888,8.8.8.8/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f wgcf* wireguard-go*
grep -qE '^[ ]*label[ ]*2002::/16[ ]*2' /etc/gai.conf || echo 'label 2002::/16   2' | sudo tee -a /etc/gai.conf
yellow " 检测是否成功启动Warp！\n 显示IPV6地址：$(wget -qO- -6 ip.gs) "
green " 如上方显示IPV6地址：2a09:…………，则说明成功！\n 如上方IPV6显示本地IP，则说明失败喽！ "
}


function cwarp(){
systemctl stop wg-quick@wgcf
systemctl disable wg-quick@wgcf
reboot
}

function owarp(){
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
}

function macka(){
wget -P /root -N --no-check-certificate "https://raw.githubusercontent.com/mack-a/v2ray-agent/master/install.sh" && chmod 700 /root/install.sh && /root/install.sh
}

function phlinhng(){
curl -fsSL https://cdn.jsdelivr.net/gh/phlinhng/v2ray-tcp-tls-web@main/src/xwall.sh -o ~/xwall.sh && bash ~/xwall.sh
}

function eure(){
wget -N --no-check-certificate https://cdn.jsdelivr.net/gh/YG-tsj/EUservRenew/EuRe.sh && chmod +x EuRe.sh && ./EuRe.sh
}

function reboot(){
reboot
}

function status(){
systemctl status wg-quick@wgcf
}

function up4(){
wget -N --no-check-certificate https://raw.githubusercontent.com/ygkkk/EUservWARP/main/wgmd.sh && chmod +x wgmd.sh && ./wgmd.sh
}

function up6(){
echo -e nameserver 2a00:1098:2c::1 > /etc/resolv.conf
wget -6 -N --no-check-certificate https://raw.githubusercontent.com/ygkkk/EUservWARP/main/wgmd.sh && chmod +x wgmd.sh && ./wgmd.sh
}

#主菜单
function start_menu(){
    clear
    yellow " 详细说明 https://github.com/ygkkk/EUservWARP  YouTube频道：甬哥侃侃侃" 
    
    red " 切记：进入脚本快捷方式 bash wgmd.sh "
    
    white " ==================一、VPS相关调整选择（更新中）==========================================" 
    
    
    
    white " ==================二、“wg模式”WARP功能选择（更新中）======================================"
    
    yellow " ----VPS原生IP数------------------------------------添加WARP虚拟IP的位置--------------"
    
    green " 2. 纯IPV6的VPS。                                  添加WARP虚拟IPV4               "
    
    green " 3. 纯IPV6的VPS。                                  添加WARP虚拟IPV4+虚拟IPV6       "
    
    green " 4. 纯IPV6的VPS。                                  添加WARP虚拟IPV6               "
    
    white " ------------------------------------------------------------------------------------------------"
    
    green " 5. 永久关闭WARP功能 "
    
    green " 6. 自动开启WARP功能 "
    
    green " 7. 有IPV4：更新脚本 "
    
    green " 8. 无IPV4：更新脚本 "
    
    white " ==================三、代理协议脚本选择（更新中）==========================================="
    
    green " 9. 使用mack-a脚本（支持Xray, V2ray） "
    
    green " 10. 使用phlinhng脚本（支持Xray, Trojan-go, SS+v2ray-plugin） "
    
    white " ============================================================================================="
    
    green " 11. 重启VPS实例，请重新连接SSH "
    
    white " ===============================================================================================" 
    
    green " 0. 退出脚本 "
    Print_ALL_Status_menu
    echo
    read -p "请输入数字:" menuNumberInput
    case "$menuNumberInput" in
        2 )
           w64
	;;
        3 )
           w646
	;;
        4 )
           w66
	;;
	5 )
           cwarp
	;;
	6 )
           owarp
	;;
	7 )
           up4
	;;
	8 )
           up6
	;;
	9 )
           macka
	;;
	10 )
           phlinhng
	;;
	11 )
           reboot
	;;
        0 )
            exit 1
        ;;
    esac
}


start_menu "first"  


else
 yellow "此CPU架构不是X86,也不是ARM！奥特曼架构？"
 exit 1
fi
