#!/bin/sh
# Bring up host level networking, requires CAP_NET_ADMIN or sudo


ip link set up sw1
ip link set up sw2

ip addr add 192.168.2.21/24 dev sw1
ip addr add 192.168.2.22/24 dev sw2

