# Web Server Benchmark
This project benchmarks the performance of three web servers: **Apache**, **NGINX**, and **Lighttpd** under minimal load. 
 
🧠 CPU Monitor Script
This script checks real-time CPU usage and warns when usage is critically high.

- `cpu_alert.sh` — Monitors CPU usage and prints a warning if it exceeds 80%.
- Uses `top` and `awk` to calculate busy CPU percentage.
- Simulated CPU load with `stress` to validate functionality.
- Can be run in a loop for continuous monitoring:
  ```bash
  while true; do ./cpu_alert.sh; sleep 2; done

### 📂 Files
- `apache_test.sh`, `nginx_test.sh`, `lighttpd_test.sh` – Shell scripts to install and test each server.
- `*_cpu.log` – CPU usage logs for each server.
- `benchmark_report.md` – Report comparing the performance results.

### 🧪 Tools Used
- `curl` & `time` for HTTP response benchmarking
- `top` for CPU load monitoring
- Shell scripting & Ubuntu EC2 instance

### 📊 Summary
The benchmark evaluates:
- Server responsiveness
- CPU efficiency under curl-based load
- Ease of configuration

> ### Filesystem Health & Quota Simulation

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
