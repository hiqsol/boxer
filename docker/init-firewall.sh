#!/bin/bash
# DNS
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT

# Allowed hosts (from ALLOWED_HOSTS env var)
# Resolve each host to all IPs so connections aren't blocked by DNS round-robin
for host in $ALLOWED_HOSTS; do
    for ip in $(getent ahostsv4 "$host" 2>/dev/null | awk '{print $1}' | sort -u); do
        iptables -A OUTPUT -d "$ip" -j ACCEPT
    done
done

# Block everything else
iptables -A OUTPUT -j DROP
