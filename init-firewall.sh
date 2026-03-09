#!/bin/bash
# DNS
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT

# Anthropic API
iptables -A OUTPUT -d api.anthropic.com -j ACCEPT

# npm, GitHub, pip — за потреби
iptables -A OUTPUT -d registry.npmjs.org -j ACCEPT
iptables -A OUTPUT -d github.com -j ACCEPT

# Все інше — блок
iptables -A OUTPUT -j DROP
