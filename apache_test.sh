#!/bin/bash

echo "📡 Starting Apache Benchmark"

# Start Apache just in case it's not running
sudo systemctl start apache2
sleep 2

# Record CPU usage for 5 seconds
echo "🧠 Measuring CPU usage..."
sar -u 1 5 > apache_cpu.log &
sar_pid=$!

# Measure response time of the Apache default page
echo "⏱️ Measuring response time..."
response_time=$( (time -p curl -s http://localhost) 2>&1 | awk '/real/ {print $2}' )

# Wait for sar to finish
wait $sar_pid

# Get average CPU usage from sar
cpu_usage=$(awk '/Average/ {print 100 - $8}' apache_cpu.log)

# Show results
echo ""
echo "🔎 Apache Benchmark Results:"
echo "Response Time: ${response_time}s"
echo "Average CPU Usage: ${cpu_usage}%"
