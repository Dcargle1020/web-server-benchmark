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
