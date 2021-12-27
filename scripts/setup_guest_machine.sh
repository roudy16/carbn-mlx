#!/bin/bash

# setup guest kernel
curl --unix-socket /tmp/firecracker.socket -i \
  -X PUT 'http://localhost/boot-source'   \
  -H 'Accept: application/json'           \
  -H 'Content-Type: application/json'     \
  -d "{
        \"kernel_image_path\": \"${VM_BASE_KERNEL}\",
        \"boot_args\": \"console=ttyS0 reboot=k panic=1 pci=off\"
    }"

# setup guest root file system
curl --unix-socket /tmp/firecracker.socket -i \
  -X PUT 'http://localhost/drives/rootfs' \
  -H 'Accept: application/json'           \
  -H 'Content-Type: application/json'     \
  -d "{
        \"drive_id\": \"rootfs\",
        \"path_on_host\": \"${VM_BASE_ROOTFS}\",
        \"is_root_device\": true,
        \"is_read_only\": false
    }"

# setup guest network
sudo ip tuntap add ${VM_GUEST_TAP_DEVICE_NAME} mode tap
sudo ip addr add 172.16.0.1/24 dev ${VM_GUEST_TAP_DEVICE_NAME}
sudo ip link set ${VM_GUEST_TAP_DEVICE_NAME} up
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
sudo iptables -t nat -A POSTROUTING -o ${VM_HOST_NETWORK_DEVICE_NAME} -j MASQUERADE
sudo iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i ${VM_GUEST_TAP_DEVICE_NAME} -o ${VM_HOST_NETWORK_DEVICE_NAME} -j ACCEPT

curl --unix-socket /tmp/firecracker.socket -i \
  -X PUT "http://localhost/network-interfaces/${VM_HOST_NETWORK_DEVICE_NAME}" \
  -H 'Accept: application/json' \
  -H 'Content-Type: application/json' \
  -d "{
      \"iface_id\": \"${VM_HOST_NETWORK_DEVICE_NAME}\",
      \"guest_mac\": \"AA:FC:00:00:00:01\",
      \"host_dev_name\": \"${VM_GUEST_TAP_DEVICE_NAME}\"
    }"
