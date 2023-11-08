# Install PVE 安装PVE 


# Make install Media 制作安装介质

# Kernel configure 内核设置

## grub configure 引导设置
    
    edit /etc/default/grub
文件如下

    GRUB_CMDLINE_LINUX_DEFAULT="intel_iommu=on iommu=pt video=efifb:off i915.enable_gvt=1 pci_pt_e820_access=on pci=assign-busses pcie_acs_override=downstream,multifunction"
    
## Kernel modlues
    edit /etc//etc/modules-load.d/modules.conf
文件如下 

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
    edit  /etc/modules-load.d/gvt.conf

文件如下

    # below is gvt need modlues
    # 下面是intel gvt所需的驱动么,每一行一个驱动!
    kvmgt
    mdev
## pci passthru pci直通需要设置
    edit /etc/modprobe.d/vfio.conf

文件如下

    # 每一行是一个驱动的自定义
    options vfio_iommu_type1 allow_unsafe_interrupts=1  #允许不安全的中断，直通必须
    #options vfio-pci ids=8086:3e96,8086:a352,8086:1528 #屏蔽直通的pci id,这里面包含的信息,比如8086是制造商,这里就是intel,1528是产品型号。
    options vfio-pci ids=8086:a352,8086:1528
### 查看pci id,命令行下面输入
cmd input like this 

    lspci -nn -D

输出类似下面内容

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

内容组成

    0000:00:00.0 Host bridge [0600]: Intel Corporation 8th Gen Core Processor Host Bridge/DRAM Registers [8086:3ec6] (rev 07)

    1. pci id 总线位置 ;
    2. 设备名称；
    3. 制造商和型号 id 8086:3ec6 ,大家注意到只要是intel的设备都是8086,那是因为这个8086就是制造商的代码;
    4. 电源状态, rev 07 rec 10,如果是断电是rev ff, 我记得大概是这样。


# sr-iov 设置
**sr-iov 科普**
    
    SR-IOV 技术是一种基于硬件的虚拟化解决方案，可提高性能和可伸缩性。SR-IOV 标准允许在虚拟机之间高效共享 PCIe（Peripheral Component Interconnect Express，快速外设组件互连）设备，并且它是在硬件中实现的，可以获得能够与本机性能媲美的 I/O 性能。SR-IOV 规范定义了新的标准，根据该标准，创建的新设备可允许将虚拟机直接连接到 I/O 设备。
**sr-iov 常用领域**
1.主要是网络设备；
2.显卡设备， Intel比较新的显卡也支持这个技术;
## 查看设置是否支持 sr-iov
    一般来说10G以上的网卡才支持这个技术,显卡也是特定设备才支持。Intel 12代以后的核显好像支持,具体自己查一下,我手头没有设备所以没有太关注这个。
命令代码
    




