#!/bin/bash

# Set threshold for alert
THRESHOLD=80

# Use top in batch mode and extract idle CPU %
IDLE=$(top -bn1 | grep "Cpu(s)" | awk -F'id,' -v prefix="$prefix" \
  '{ split($1, vs, ","); v=vs[length(vs)]; sub("%", "", v); print 100 - v }')

# Round down to integer
CPU_BUSY=${IDLE%.*}

# Print current usage
echo "Current CPU Usage: $CPU_BUSY%"

# Alert if over threshold
if [ "$CPU_BUSY" -ge "$THRESHOLD" ]; then
    echo "⚠️  High CPU Usage Detected: $CPU_BUSY%" | tee -a cpu_alert.log
else
    echo "CPU usage is normal."
fi
