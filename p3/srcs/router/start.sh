#!/bin/sh
kill -9 $(cat /var/run/frr/*.pid 2>/dev/null) 2>/dev/null
rm -f /var/run/frr/*.pid
sleep 1
/usr/lib/frr/frrinit.sh start
exec /bin/sh
