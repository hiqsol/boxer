#!/bin/bash
# DNS
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT

# Allowed hosts (from ALLOWED_HOSTS env var)
for host in $ALLOWED_HOSTS; do
    iptables -A OUTPUT -d "$host" -j ACCEPT
done

# Block everything else
iptables -A OUTPUT -j DROP
