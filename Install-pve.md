# Install PVE 安装PVE 
    此处省略 1K
# Make install Media 制作安装介质
    此处省略 1K
# 重点开始
# Kernel configure 内核设置

## grub configure 引导设置
**编辑下面文件**

    nano /etc/default/grub

**文件如下**

    GRUB_CMDLINE_LINUX_DEFAULT="intel_iommu=on iommu=pt video=efifb:off i915.enable_gvt=1 pci_pt_e820_access=on pci=assign-busses pcie_acs_override=downstream,multifunction"
    
## Kernel modlues
    edit /etc//etc/modules-load.d/modules.conf

**文件如下**

    # /etc/modules: kernel modules to load at boot time.
    #
    # This file contains the names of kernel modules that should be loaded
    # at boot time, one per line. Lines beginning with "#" are ignored.
    # Parameters can be specified after the module name.
    # 下面的有关 pci直通所需的驱动 
    # below is pci passthru need modules
    vfio
    vfio_iommu_type1 
    vfio_pci
    vfio_virqfd
## intel gvt configure 英特尔虚拟显卡设置 
**编辑下面文件**
    
    nano  /etc/modules-load.d/gvt.conf

**文件如下**

    # below is gvt need modlues
    # 下面是intel gvt所需的驱动么,每一行一个驱动!
    kvmgt
    mdev
## pci passthru pci直通需要设置
**编辑下面文件**

    nano /etc/modprobe.d/vfio.conf

**文件如下**

    # 每一行是一个驱动的自定义
    options vfio_iommu_type1 allow_unsafe_interrupts=1  #允许不安全的中断，直通必须
    #options vfio-pci ids=8086:3e96,8086:a352,8086:1528 #屏蔽直通的pci id,这里面包含的信息,比如8086是制造商,这里就是intel,1528是产品型号。
    options vfio-pci ids=8086:a352,8086:1528
### 查看pci id,命令行下面输入
**cmd input like this**

    lspci -nn -D

***输出类似下面内容***

    0000:00:00.0 Host bridge [0600]: Intel Corporation 8th Gen Core Processor Host Bridge/DRAM Registers [8086:3ec6] (rev 07)
    0000:00:01.0 PCI bridge [0604]: Intel Corporation 6th-10th Gen Core Processor PCIe Controller (x16) [8086:1901] (rev 07)
    0000:00:01.1 PCI bridge [0604]: Intel Corporation Xeon E3-1200 v5/E3-1500 v5/6th Gen Core Processor PCIe Controller (x8) [8086:1905] (rev 07)
    0000:00:02.0 Display controller [0380]: Intel Corporation CoffeeLake-S GT2 [UHD Graphics P630] [8086:3e96]
    0000:00:08.0 System peripheral [0880]: Intel Corporation Xeon E3-1200 v5/v6 / E3-1500 v5 / 6th/7th/8th Gen Core Processor Gaussian Mixture Model [8086:1911]
    0000:00:12.0 Signal processing controller [1180]: Intel Corporation Cannon Lake PCH Thermal Controller [8086:a379] (rev 10)
    0000:00:14.0 USB controller [0c03]: Intel Corporation Cannon Lake PCH USB 3.1 xHCI Host Controller [8086:a36d] (rev 10)
    0000:00:14.2 RAM memory [0500]: Intel Corporation Cannon Lake PCH Shared SRAM [8086:a36f] (rev 10)
    0000:00:15.0 Serial bus controller [0c80]: Intel Corporation Cannon Lake PCH Serial IO I2C Controller #0 [8086:a368] (rev 10)
    0000:00:15.1 Serial bus controller [0c80]: Intel Corporation Cannon Lake PCH Serial IO I2C Controller #1 [8086:a369] (rev 10)
    0000:0b:00.0 PCI bridge [0604]: ASPEED Technology, Inc. AST1150 PCI-to-PCI Bridge [1a03:1150] (rev 04)
    0000:0c:00.0 VGA compatible controller [0300]: ASPEED Technology, Inc. ASPEED Graphics Family [1a03:2000] (rev 41)
    0000:0d:00.0 Non-Volatile memory controller [0108]: Sandisk Corp WD Blue SN550 NVMe SSD [15b7:5009] (rev 01)
    0000:0e:00.0 Non-Volatile memory controller [0108]: Samsung Electronics Co Ltd NVMe SSD Controller SM981/PM981/PM983 [144d:a808]

**内容组成**

    0000:00:00.0 Host bridge [0600]: Intel Corporation 8th Gen Core Processor Host Bridge/DRAM Registers [8086:3ec6] (rev 07)

    1. pci id 总线位置 ;
    2. 设备名称；
    3. 制造商和型号 id 8086:3ec6 ,大家注意到只要是intel的设备都是8086,那是因为这个8086就是制造商的代码;
    4. 电源状态, rev 07 rec 10,如果是断电是rev ff, 我记得大概是这样。


# sr-iov 设置

**sr-iov 科普**
    
    SR-IOV 技术是一种基于硬件的虚拟化解决方案，可提高性能和可伸缩性。SR-IOV 标准允许在虚拟机之间高效共享 PCIe（Peripheral Component Interconnect Express，快速外设组件互连）设备，并且它是在硬件中实现的，可以获得能够与本机性能媲美的 I/O 性能。SR-IOV 规范定义了新的标准，根据该标准，创建的新设备可允许将虚拟机直接连接到 I/O 设备。

**sr-iov 常用领域**

1. 主要是网络设备；
2. 显卡设备， Intel比较新的显卡也支持这个技术;

## 查看设置是否支持 sr-iov

    一般来说10G以上的网卡才支持这个技术,显卡也是特定设备才支持。Intel 12代以后的核显好像支持,具体自己查一下,我手头没有设备所以没有太关注这个。

**命令代码**

1. 查询网卡 pci address
    lspci | grep -i net

**内容类似**

    01:00.0 Ethernet controller: Intel Corporation 82599ES 10-Gigabit SFI/SFP+ Network Connection (rev 01)
    01:00.1 Ethernet controller: Intel Corporation 82599ES 10-Gigabit SFI/SFP+ Network Connection (rev 01)
    02:10.1 Ethernet controller: Intel Corporation 82599 Ethernet Controller Virtual Function (rev 01)
    02:10.3 Ethernet controller: Intel Corporation 82599 Ethernet Controller Virtual Function (rev 01)
    03:00.0 Ethernet controller: Intel Corporation Ethernet Controller 10-Gigabit X540-AT2 (rev 01)
    03:00.1 Ethernet controller: Intel Corporation Ethernet Controller 10-Gigabit X540-AT2 (rev 01)
    06:00.0 Ethernet controller: Intel Corporation I210 Gigabit Network Connection (rev 03)
    07:00.0 Ethernet controller: Intel Corporation I210 Gigabit Network Connection (rev 03)
    08:00.0 Ethernet controller: Intel Corporation I210 Gigabit Network Connection (rev 03)
    09:00.0 Ethernet controller: Intel Corporation I210 Gigabit Network Connection (rev 03)

**或者**
    
    cmd# ethtool -i enp3s0f0

**内容如下**

    driver: ixgbe
    version: 6.2.16-19-pve
    firmware-version: 0x80000528
    expansion-rom-version:
    bus-info: 0000:03:00.0
    supports-statistics: yes
    supports-test: yes
    supports-eeprom-access: yes
    supports-register-dump: yes
    supports-priv-flags: yes

2. 查看设备是否支持 SR-IOV 
    cmd# lspci -v -s 0000:03:00.0

**内容如下**

    03:00.0 Ethernet controller: Intel Corporation Ethernet Controller 10-Gigabit X540-AT2 (rev 01)
	Subsystem: Intel Corporation Ethernet Controller 10-Gigabit X540-AT2
	Flags: bus master, fast devsel, latency 0, IRQ 18, IOMMU group 23
	Memory at 90000000 (64-bit, prefetchable) [size=2M]
	Memory at 90400000 (64-bit, prefetchable) [size=16K]
	Expansion ROM at 93780000 [disabled] [size=512K]
	Capabilities: [40] Power Management version 3
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable+ 64bit+
	Capabilities: [70] MSI-X: Enable+ Count=64 Masked-
	Capabilities: [a0] Express Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [150] Alternative Routing-ID Interpretation (ARI)
	Capabilities: [160] Single Root I/O Virtualization (SR-IOV)
	Capabilities: [1d0] Access Control Services
	Kernel driver in use: ixgbe
	Kernel modules: ixgbe  

**Notice**

    Capabilities: [160] Single Root I/O Virtualization (SR-IOV)

**有这句就是支持 SR-IOV**

## 开始设置 
### 开始设置之前,建议更新initramfs和grub

# 注意⚠️注意⚠️注意⚠️ ｜ Notice
**因为开启相关直通,重启后设备会更改pci设备的地址,比如我的网卡设备地址就从 1,2,3,4; 变成了 6,7,8,9;
万兆网卡的pci设备地址也发生了变化。**

    update-initramfs -u -k all
    update-grub
    proxmox-boot-tool refresh

**重启后设备**

    reboot

**编辑下面文件**

    /etc/modprobe.d/sr-iov.conf

**内容如下**
    # options 你的网卡驱动 最大虚拟网卡数量
    # options intel 万兆网卡驱动 ixgbe 最大虚拟网卡数量,我设置的是4
    options ixgbe max_vfs=4
### 根据pve文档建议,用sysfs修改
**安装sysfsutils工具**

    apt install sysfsutils

**修改sysfs.conf**

    nano sysfs.conf

**原来内容如下**

    # /etc/sysfs.conf - Configuration file for setting sysfs attributes.
    # Always use the powersave CPU frequency governor
   ......

**结尾添加如下**

    # 添加如下内容，我一般修改完了会加上修改原因和时间；
    # 2023-11-03 edit by ob_ sr-iov xt540 xt520 max_fs=4;
    # bus/pci/devices/这里改成你的网卡pci地址/sriov_numvfs=你需要的数字,我这里是4;
    # 我给其中3个网卡开了vf,其它的几个我直通给虚拟机了；
    bus/pci/devices/0000:01:00.1/sriov_numvfs=4
    bus/pci/devices/0000:03:00.0/sriov_numvfs=4
    bus/pci/devices/0000:03:00.1/sriov_numvfs=4

## SR-IOV 开机相关设置
**需要设置好相应的虚拟网卡 mac address,还有设置好开机启动,pve默认网卡的行为是down!

开机简单脚本**

    cat /lib/systemd/system/sr-iov.service

**内容如下**

    [Unit]
    Description=Script to enable SR-IOV on boot
    Before=network.target # 设置在网络服务之前启动,怕引起不必要的错误！

    [Service]
    ExecStart=/usr/bin/sr-iov.sh
    Type=oneshot
    RemainAfterExit=yes

    [Install]
    WantedBy=multi-user.target

**设置文件**

    /usr/bin/sr-iov.sh

**内容如下**

    cat /usr/bin/sr-iov.sh

**保存下面内容**

    #!/bin/sh
    # set x520 port 1&2 up
    ip link set dev enp1s0f0 up
    ip link set dev enp1s0f1 up
    ip link set dev enp1s0f1v0 up
    ip link set dev enp1s0f1v1 up
    ip link set dev enp1s0f1v2 up
    ip link set dev enp1s0f1v3 up

    # set x540 port 1&2 up
    ip link set dev enp3s0f0 up
    ip link set dev enp3s0f1 up
    ip link set dev enp3s0f1v0 up
    ip link set dev enp3s0f1v1 up
    ip link set dev enp3s0f1v2 up
    ip link set dev enp3s0f1v3 up

    # set x520 vf 0-4 static mac address port1
    ip link set dev enp1s0f0 vf 0 mac 00:52:6b:a5:a3:11
    ip link set dev enp1s0f0 vf 1 mac 00:52:6b:a5:a3:12
    ip link set dev enp1s0f0 vf 2 mac 00:52:6b:a5:a3:13
    ip link set dev enp1s0f0 vf 3 mac 00:52:6b:a5:a3:14
    # set x520 vf 0-4 static mac address port2
    ip link set dev enp1s0f1 vf 0 mac 00:52:6b:a5:a3:21
    ip link set dev enp1s0f1 vf 1 mac 00:52:6b:a5:a3:22
    ip link set dev enp1s0f1 vf 2 mac 00:52:6b:a5:a3:23
    ip link set dev enp1s0f1 vf 3 mac 00:52:6b:a5:a3:24

    # set x540 vf 0-4 static mac address port1
    ip link set dev enp3s0f0 vf 0 mac 00:54:6b:a5:a3:11
    ip link set dev enp3s0f0 vf 1 mac 00:54:6b:a5:a3:12
    ip link set dev enp3s0f0 vf 2 mac 00:54:6b:a5:a3:13
    ip link set dev enp3s0f0 vf 3 mac 00:54:6b:a5:a3:14 
    # set x540 vf 0-4 static mac address port2
    ip link set dev enp3s0f1 vf 0 mac 00:54:6b:a5:a3:21
    ip link set dev enp3s0f1 vf 1 mac 00:54:6b:a5:a3:22
    ip link set dev enp3s0f1 vf 2 mac 00:54:6b:a5:a3:23
    ip link set dev enp3s0f1 vf 3 mac 00:54:6b:a5:a3:24

***添加执行权限***

    chmod +x sr-iov.sh

**启动守护进程**

    systemd daemon-reload
    systemd enable sr-iov

# 收尾工作

## 更新ininramfs
    update-initramfs -u -k all
## 更新grub 引导程序
    update-grub
    proxmox-boot-tool refresh

## 重启机器
    reboot

# Enjoy && 享受你的PVE欢乐人生
    thanks for reading!!!
    


