#!/bin/bash
set -e

# Firewall as root (needs CAP_NET_ADMIN) — must succeed or abort
/usr/local/bin/init-firewall.sh || { echo "FATAL: firewall init failed" >&2; exit 1; }

# Get the non-root user (first user with UID >= 1000)
CODER=$(getent passwd | awk -F: '$3 >= 1000 && $3 < 65534 {print $1; exit}')

# Drop privileges and exec
exec gosu "$CODER" "$@"
