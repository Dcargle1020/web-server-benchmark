# Web Server Benchmark
This project benchmarks the performance of three web servers: **Apache**, **NGINX**, and **Lighttpd** under minimal load. 
 
🔍 CPU Overuse Detection & Alert Script
## Scenario Summary
You're tasked with building a lightweight CPU monitor that alerts when CPU usage exceeds a critical threshold (>= 80%). This helps detect system strain early and proactively respond before services are impacted.This script checks real-time CPU usage and warns when usage is critically high.

## Objectives
- Use tools like `uptime`, `top`, or `sar` to monitor CPU usage.
- Extract idle CPU data using `awk` and calculate CPU busy time.
- If busy time ≥ 80%, write a warning to a log file.
- 
- ## Tools Used
- `uptime`
- `awk`
- `bash scripting`-
- 
- Can be run in a loop for continuous monitoring:
  ## Implementation Details

### Script Overview

```bash
#!/bin/bash

# Get current CPU idle percentage
idle=$(uptime | awk -F'load average: ' '{print $2}' | awk -F', ' '{print $1}')

# Using 'top' to grab the idle CPU if needed (alternative method)
# idle=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print $1}')

# Simulate calculation: assume 100% - idle = busy (for demonstration)
cpu_busy=$(echo "100 - $idle" | bc)

# Threshold check
if (( $(echo "$cpu_busy >= 80" | bc -l) )); then
    echo "$(date): WARNING - High CPU usage detected: ${cpu_busy}% busy" >> cpu_alert.log
else
    echo "$(date): CPU usage normal: ${cpu_busy}% busy" >> cpu_alert.log
fi
### Sample Output in `cpu_alert.log`
```
Mon Jul 22 11:23:45 UTC 2025: CPU usage normal: 42.5% busy
Mon Jul 22 12:45:02 UTC 2025: WARNING - High CPU usage detected: 85.7% busy
```
## Lessons Learned
- Learned to parse real-time CPU stats using built-in tools.
- Practiced working with system text streams using `awk`, `bc`, and pipelines.
- Reinforced conditional logic and logging in Bash.
> ### Filesystem Health & Quota Simulation
✅ Completed and tested as part of hands-on lab series in Cloud Engineering Bootcamp.

Simulated low-inode exhaustion and user quota enforcement:
- Created a loop device and formatted with `ext4` (with limited inodes)
- Mounted with `usrquota` and verified quota support
- Used `touch` in a loop to hit inode exhaustion
- Enabled user quotas with `quotacheck`, `repquota`
- Verified enforcement via quota report
- > This lab was completed on an AWS EC2 instance running Ubuntu 24.04.
Tools: `fallocate`, `mkfs.ext4`, `mount`, `df -i`, `quotacheck`, `repquota`

# 🔒 ICMP Blocking with `sysctl` & `firewalld`
**Linux Scenario* Simulate and block ICMP (ping) traffic using `sysctl` and `firewalld` tools in a Linux environment.
## ✅ Goals
- Use `sysctl` to block all ICMP echo requests (ping).
- Use `firewalld` to block ICMP at the network firewall level.
- Confirm 100% packet loss via `ping` test.
- Demonstrate troubleshooting process and learn to work around system-level and AWS-level constraints.
---
## 🧠 Key Tools

| Tool         | Purpose                              |
|--------------|---------------------------------------|
| `sysctl`     | Kernel-level configuration change     |
| `firewalld`  | Zone-based firewall management tool   |
| `ping`       | ICMP test for reachability            |
| `nmcli`      | Interface management (if needed)      |

---
## 🧪 Commands Used

### 🔹 Attempted to block ICMP at kernel level:

```bash
sudo sysctl -w net.ipv4.icmp_echo_ignore_all=1
```
### 🔹 Verified setting:

```bash
cat /proc/sys/net/ipv4/icmp_echo_ignore_all
```
### 🔹 Tested ping:

```bash
ping -c 3 192.168.88.150
```
**Result:** Still received ping responses (0% packet loss)

---
### 🔹 Attempted ICMP block with firewalld:

```bash
sudo firewall-cmd --zone=public --add-icmp-block=echo-request
sudo firewall-cmd --reload
```
### 🔹 Verified zone and interface:

```bash
sudo firewall-cmd --get-active-zones
sudo firewall-cmd --zone=public --list-interfaces
```
### 🔹 Attempted to block all ICMP with inversion:

```bash
sudo firewall-cmd --zone=public --add-icmp-block-inversion
```
**Note:** Command executed successfully but **ping still worked.**
---
## 📉 Observed Outcome

Despite running the correct commands for both `sysctl` and `firewalld`, ICMP packets were **still being received** by the machine. Ping results consistently showed:
```
3 packets transmitted, 3 received, 0% packet loss
```
## 🔍 Troubleshooting & Hypotheses
- ✅ Commands were correctly formatted and applied.
- ✅ Kernel-level sysctl setting verified.
- ❓ Possible reasons for test not reflecting expected behavior:
  - Running the `ping` test on the **same machine** (loopback bypass).
  - There may have restrictions or NAT/firewall handling that overrides these settings.
  - **VPC-level routing** or **security group configurations** may override local settings.
  - `firewalld` zone might not be properly mapped to interface in a cloud VM.
---
## 🧩 Next Steps (If Full Access Allowed)
- [ ] Launch a second EC2 instance in the same **subnet**.
- [ ] Ping the first instance **from the second machine** to test true external ICMP block.
- [ ] Check VPC route tables and network ACLs.
- [ ] Use `tcpdump` or `nmap` for deeper visibility into blocked/allowed packets.

---
## 📝 Final Notes

Although the ICMP block could not be fully verified due to environment limitations, I completed all expected configuration steps, demonstrated critical thinking through layered troubleshooting, and documented a plan for how to fully validate in a less restricted environment.
