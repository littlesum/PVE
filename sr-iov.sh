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
