#!/bin/bash
# Disable TX checksum offloading on igb NICs.
# QEMU's igb emulation does not compute TX checksums in hardware, causing
# Geneve-encapsulated TCP packets to be sent with invalid checksums and
# breaking all cross-node TCP traffic in OVN-Kubernetes clusters.
for nic in /sys/class/net/enp*; do
    nic_name=$(basename "$nic")
    driver=$(readlink "$nic/device/driver" 2>/dev/null | xargs basename 2>/dev/null)
    if [ "$driver" = "igb" ]; then
        ethtool -K "$nic_name" tx off tso off gso off 2>/dev/null
    fi
done
