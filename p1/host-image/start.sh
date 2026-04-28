#!/bin/sh
set -eu

echo "Host node ready. No IP address is configured by default."
exec tail -f /dev/null
