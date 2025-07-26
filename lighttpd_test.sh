#!/bin/bash

echo "📡 Starting Lighttpd Benchmark"

# Start Lighttpd
sudo systemctl start lighttpd
sleep 2

# Record CPU usage for 5 seconds
echo "🧠 Measuring CPU usage..."
sar -u 1 5 > lighttpd_cpu.log &
sar_pid=$!

# Measure response time of the default page
echo "⏱️ Measuring response time..."
response_time=$( (time -p curl -s http://localhost) 2>&1 | awk '/real/ {print $2}' )

# Wait for sar to finish
wait $sar_pid

# Get average CPU usage from sar
cpu_usage=$(awk '/Average/ {print 100 - $8}' lighttpd_cpu.log)

# Show results
echo ""
echo "🔎 Lighttpd Benchmark Results:"
echo "Response Time: ${response_time}s"
echo "Average CPU Usage: ${cpu_usage}%"
