### 给EUserv IPV6添加WARP，白嫖WARP高速通道！

### 德鸡续期一键脚本项目（小白专享）：https://github.com/ygkkk/Djxq

### IPV6 only VPS添加WARP的好处：

1：使只有IPV6的VPS获取访问IPV4的能力，套上WARP的ip,变成双栈VPS！

2：基本能隐藏VPS的真实IP！

3：支持代理协议直连电报Telegram，支持代理协议连通软路由Openwrt各种翻墙插件！

4：支持原本需要IPV4支持的Docker等应用！

5：加速VPS到CloudFlare CDN节点访问速度！

6：避开原VPS的IP需要谷歌验证码问题（目前无法彻底避开啦）！

7：替代NAT64/DNS64方案，网络效率更高！

-------------------------------------------------------------------------------------------------------


### 仅支持Debian 10/Ubuntu 20.04系统一键综合脚本
```
wget -N --no-check-certificate https://cdn.jsdelivr.net/gh/ygkkk/EUservWARP/wgmd.sh && chmod +x wgmd.sh && ./wgmd.sh
```
进入脚本快捷方式 ```bash wgmd.sh```

#### 脚本2：IPV4是WARP分配的IP，IPV6是VPS本地IP

#### 脚本3：IPV4与IPV6都是WARP分配的IP

#### 脚本4：IPV6是WARP分配的IP，无IPV4（估计目前没人会选择脚本4。。。）

- [刷新脚本](https://purge.jsdelivr.net/gh/ygkkk/EUservWARP/wgmd.sh)

----------------------------------------------------------------------------------------------------

#### 注意：域名解析所填写的IP必须是VPS本地IP，与WARP分配的IP没关系！

#### 推荐使用Xray脚本项目（mack-a）：https://github.com/mack-a/v2ray-agent 

#### 提示：配置文件wgcf.conf和注册文件wgcf-account.toml都已备份在/etc/wireguard目录下！
--------------------------------------------------------------------------------------------------------------

#### 查看WARP当前统计状态：```wg```

------------------------------------------------------------------------------------------------------------- 
#### IPV6 VPS专用分流配置文件(以下默认全局IPV4优先，IP、域名自定义，视频教程以后更新)
```
{ 
"outbounds": [
    {
      "tag":"IP6-out",
      "protocol": "freedom",
      "settings": {}
    },
    {
      "tag":"IP4-out",
      "protocol": "freedom",
      "settings": {
        "domainStrategy": "UseIPv4" 
      }
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "outboundTag": "IP4-out",
        "domain": [""] 
      },
      {
        "type": "field",
        "outboundTag": "IP6-out",
        "network": "udp,tcp" 
      }
    ]
  }
}
``` 
 ---------------------------------------------------------------------------------------------------------

#### 相关WARP进程命令

手动临时关闭WARP网络接口
```
wg-quick down wgcf
```
手动开启WARP网络接口 
```
wg-quick up wgcf
```

启动systemctl enable wg-quick@wgcf

开始systemctl start wg-quick@wgcf

重启systemctl restart wg-quick@wgcf

停止systemctl stop wg-quick@wgcf

关闭systemctl disable wg-quick@wgcf

-------------------------------------------------------------------------------------------------------

### TG群：https://t.me/joinchat/nrUoeEJV_9UxNDhl
### YouTube频道：https://www.youtube.com/channel/UCxukdnZiXnTFvjF5B5dvJ5w

---------------------------------------------------------------------------------------------------------

感谢P3terx大及原创者们，参考来源：
 
https://p3terx.com/archives/debian-linux-vps-server-wireguard-installation-tutorial.html

https://p3terx.com/archives/use-cloudflare-warp-to-add-extra-ipv4-or-ipv6-network-support-to-vps-servers-for-free.html

https://luotianyi.vc/5252.html

https://hiram.wang/cloudflare-wrap-vps/
