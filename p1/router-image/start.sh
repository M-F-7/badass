#!/bin/sh
set -eu

# This image is a reusable base for all BADASS parts.
# Keep the node generic: no interface IPs are configured here.
sysctl -w net.ipv4.ip_forward=1 >/dev/null || true
sysctl -w net.ipv6.conf.all.forwarding=1 >/dev/null || true

# Ensure the integrated FRR config is used.
if grep -q '^vtysh_enable=' /etc/frr/daemons; then
    sed -i 's/^vtysh_enable=.*/vtysh_enable=yes/' /etc/frr/daemons
else
    printf '\nvtysh_enable=yes\n' >> /etc/frr/daemons
fi

/usr/lib/frr/frrinit.sh start

echo "Router node ready. FRR daemons enabled: zebra bgpd ospfd isisd."
echo "No IP address is configured by default."

exec tail -f /dev/null
