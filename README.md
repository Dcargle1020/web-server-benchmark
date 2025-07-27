Web Server Benchmarking & System Simulation Lab

This project simulates real-world failure scenarios and system behavior across four key areas of cloud infrastructure: web server benchmarking, CPU monitoring, disk/inode exhaustion, and network troubleshooting.

✅ Scenario 1: Web Server Benchmarking

📌 Objective

Evaluate Apache, NGINX, and Lighttpd under minimal load using benchmarking tools.

⚙️ Tools Used

curl

time

top

sar

🧪 Method

Installed each web server.

Served basic HTML pages.

Benchmarked using curl and measured with time, top, and sar.

📊 Benchmark Results

Server

Average Response Time

CPU %

Memory Usage

Apache

130ms

4.2%

30MB

NGINX

98ms

3.0%

25MB

Lighttpd

110ms

3.5%

28MB

✅ Scenario 2: Detecting CPU Overuse and Alerting

📌 Objective

Build a lightweight CPU monitor that alerts when CPU usage crosses a critical threshold.

⚙️ Tools Used

uptime

awk

bash

🧠 Script Logic

```bash #!/bin/bash # Get the current idle CPU percent idle=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}') busy=$(echo "100 - $idle" | bc) # Log alert if CPU usage is too high if (( $(echo "$busy > 80" | bc -l) )); then echo "⚠️ Warning: High CPU Usage - ${busy}% busy" else echo "✅ CPU usage is normal: ${busy}% busy" fi ``` </pre>

📊 Benchmark Summary

Triggered alerts when CPU usage exceeded 80%

Validated by running parallel load processes

Log file saved to ~/cpu_alert.log

✅ Scenario 3: Filesystem Health & Quota Simulation

📌 Objective

Simulate inode exhaustion and user-level quota enforcement.

⚙️ Tools Used

fallocate

mkfs

mount

df -i

quotacheck, setquota, repquota

🧪 Steps Taken

Created a loop device with limited inodes:

fallocate -l 50M loopfile.img
mkfs.ext4 -N 500 loopfile.img
mount -o loop loopfile.img /mnt/testmount

Filled it with small files until inode exhaustion:

for i in {1..600}; do touch "/mnt/testmount/file$i"; done

Enabled and enforced user quotas:

mount -o usrquota loopfile.img /mnt/testmount
quotacheck -cum /mnt/testmount
edquota -u <username>

📊 Outcome

System warned on inode exhaustion

User quotas enforced successfully

Verified via repquota output

✅ Scenario 4: Network Troubleshooting (ICMP Only)

📌 Objective

Block and unblock ICMP packets using sysctl and firewalld, and test using ping and nmap.

⚙️ Tools Used

sysctl

firewall-cmd

ping

nmap

🧪 Sysctl Method

Block ICMP:

sudo sysctl -w net.ipv4.icmp_echo_ignore_all=1

Test:

ping <EC2-IP>  # Should show 100% packet loss

Unblock:

sudo sysctl -w net.ipv4.icmp_echo_ignore_all=0

🧪 firewalld Method

Block ICMP:

sudo firewall-cmd --add-icmp-block=echo-request --permanent
sudo firewall-cmd --reload

Test:

ping <EC2-IP>  # Should fail

Unblock:

sudo firewall-cmd --remove-icmp-block=echo-request --permanent
sudo firewall-cmd --reload

📊 Result

ICMP successfully blocked/unblocked via both methods

Behavior verified with ping and nmap

🧠 Reflection

This lab pushed me out of my comfort zone. I faced challenges, got stuck, learned by doing, and gained confidence in system-level troubleshooting. Writing Bash scripts, analyzing system metrics, and simulating real-world failures helped me grow into a more hands-on cloud engineer.
