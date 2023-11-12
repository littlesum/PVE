如果有静态IPv6地址的话，可以直接在PVE的WEBUI “系统 -> 网络” 的具体接口上直接设置静态IPv6地址即可。

对于家宽来说，没有静态IPv6地址的话，可以按如下方式操作：

# 1.方式一

注：无需修改/etc/sysctl.conf

复制interface

```
cp /etc/network/interfaces /etc/network/interfaces.new
```

编辑刚刚复制的/etc/network/interfaces.new，在最下方添加（如果有多个网桥，可以添加多次）：

```
nano /etc/network/interfaces.new

iface vmbr0 inet6 dhcp  # vmbr0修改为你的网桥名称
    request_prefix 1
```

在PVE的WEBUI “系统 -> 网络” 处，刷新后点击“应用配置”即可生效，等待几分钟后即可获取到IPv6地址，输入ip -6 a show vmbr0（vmbr0为网桥名称）可查看IPv6地址。

# 2.方式二

查看内核也已经开启ipv6自动配置：

```
cat /proc/sys/net/ipv6/conf/vmbr0/accept_ra
1 #返回值
cat /proc/sys/net/ipv6/conf/vmbr0/autoconf
1 #返回值
```

查看已开启ipv6转发：

```
cat /proc/sys/net/ipv6/conf/vmbr0/forwarding
1 #返回值
```

需要将accept_ra值改成2才能自动配置SLAAC ipv6地址：

```
vi /etc/sysctl.conf
```

最后边添加上如下代码

```
net.ipv6.conf.all.accept_ra=2
net.ipv6.conf.default.accept_ra=2
net.ipv6.conf.vmbr0.accept_ra=2
net.ipv6.conf.all.autoconf=1
net.ipv6.conf.default.autoconf=1
net.ipv6.conf.vmbr0.autoconf=1
```

