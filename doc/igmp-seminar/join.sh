#!/bin/sh
# Joins groups on sw1 and sw2
# requires CAP_NET_RAW or sudo

nemesis igmp -v -p 22 -S 192.168.2.21 -g 225.1.2.3 -D 225.1.2.3 -d sw1
nemesis igmp -v -p 22 -S 192.168.2.22 -g 225.1.2.4 -D 225.1.2.4 -d sw2


