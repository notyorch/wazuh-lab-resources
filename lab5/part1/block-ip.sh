#!/bin/sh
LOG_FILE="/var/ossec/logs/active-responses.log"

# Log execution call
echo "$(date) - block-ip.sh called with ARGS: $@" >> $LOG_FILE

# Extract Action and IP
# Wazuh can call this with positional arguments: $1=action, $3=ip
ACTION=$1
IP=$3

# If positional arguments are not what we expect, try to parse JSON from stdin
if [ -z "$IP" ] || [ "$IP" = "-" ]; then
    # Try to read JSON from stdin with a short timeout
    JSON_INPUT=$(python3 -c 'import sys, json, select; print(sys.stdin.readline()) if select.select([sys.stdin], [], [], 0.5)[0] else print("")')
    if [ ! -z "$JSON_INPUT" ]; then
        IP=$(echo "$JSON_INPUT" | python3 -c 'import sys, json; data=json.load(sys.stdin); alert=data.get("parameters", {}).get("alert", {}); print(alert.get("data", {}).get("srcip", alert.get("srcip", "")))' 2>/dev/null)
        ACTION_JSON=$(echo "$JSON_INPUT" | python3 -c 'import sys, json; data=json.load(sys.stdin); print(data.get("command", ""))' 2>/dev/null)
        if [ ! -z "$ACTION_JSON" ]; then
            ACTION=$ACTION_JSON
        fi
    fi
fi

# Normalize Action
case "$ACTION" in
    add|block-ip*)
        ACTION="add"
        ;;
    delete)
        ACTION="delete"
        ;;
    *)
        # If still no action, maybe it is in $1 (old style)
        if [ "$1" = "add" ] || [ "$1" = "delete" ]; then
            ACTION=$1
        else
            echo "$(date) - block-ip.sh error: unknown action ($ACTION)" >> $LOG_FILE
            exit 1
        fi
        ;;
esac

# Final check for IP
if [ -z "$IP" ] || [ "$IP" = "None" ]; then
    echo "$(date) - block-ip.sh error: IP not found" >> $LOG_FILE
    exit 1
fi

echo "$(date) - block-ip.sh processing: ACTION=$ACTION, IP=$IP" >> $LOG_FILE

# Execute iptables command
if [ "$ACTION" = "add" ]; then
    /sbin/iptables -C INPUT -s "$IP" -j DROP 2>/dev/null || /sbin/iptables -I INPUT -s "$IP" -j DROP
elif [ "$ACTION" = "delete" ]; then
    /sbin/iptables -D INPUT -s "$IP" -j DROP 2>/dev/null
fi

exit 0
