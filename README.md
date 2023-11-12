# PVE

# **记录我的PVE学习设置过程!**

## [**Install-pve.md**](https://cloud.zod.wiki/ob/pve/src/branch/main/Install-pve.md)

## [pve host ipv6 configure guide ](https://git.zod.wiki/ob/pve/src/branch/main/pve_vmbr_ipv6_configure.md)

## [PVE 主机 IPv6 设置 SLAAC ](https://git.zod.wiki/ob/pve/src/branch/main/pve_vmbr_ipv6_configure.md)

## pci passthru

## sr-iov

## Intel_GVT


# 相关设置文件

```bash
/etc/default/grub
/etc/modules-load.d/modules.conf
/etc/modules-load.d/gvt.conf
/etc/modprobe.d/sr-iov.conf
/etc/modprobe.d/vfio.conf
/etc/modprobe.d/blacklist.conf
/etc/sysfs.conf
/etc/apt/sources.list
/etc/sysctl.conf

```
# systemd scripts 相关文件
```bash
/lib/systemd/system/sr-iov.service
/usr/bin/sr-iov.sh
```
# 更新 initramfs

```bash
update-initramfs -u -k all
update-grub
proxmox-boot-tool refresh
```
# 重启

```bash
reboot
```
