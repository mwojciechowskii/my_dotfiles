#!/bin/bash
# Check if any connected ethernet interface exists
if ip link show | grep -q 'state UP' | grep -q 'eth\|enp'; then
    # Get the first connected ethernet interface name
    INTERFACE=$(ip link show | grep 'state UP' | grep 'eth\|enp' | head -n 1 | awk -F': ' '{print $2}')
    # Get the IP address
    IP=$(ip addr show $INTERFACE | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)
    echo "| ETH ${IP}"
else
    # Return empty if not connected
    echo ""
fi
