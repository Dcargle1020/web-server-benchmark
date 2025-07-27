# 🧪 Web Server Benchmark Report
This benchmark compares Apache, NGINX, and Lighttpd for a lightweight internal service under minimal load.
## 📋 Test Setup
- Response time measured using `curl` + `time`
- CPU usage captured using `sar` over 5 seconds
- Each server tested independently on an AWS EC2 Ubuntu instance
## 📊 Results Summary

| Web Server | Response Time (s) | Avg CPU Usage (%) |
|------------|-------------------|--------------------|
| Apache     | 0.02              | 0.4                |
| NGINX      | 0.01              | 0.0                |
| Lighttpd   | 0.01              | 0.4                |

## 🧠 Observations

- **NGINX** showed the best performance overall with minimal CPU use
- **Lighttpd** is nearly tied in speed but uses slightly more CPU
- **Apache** is slightly heavier, but still respectable
 ## ✅ Recommendation
For a lightweight internal service where speed and efficiency matter, **NGINX** is the top choice.

## 🧪 Filesystem Health & Quota Simulation

### Scenario:
Simulate inode exhaustion and explore quota limits to understand system behavior when the shared drive fills up.

### What I Did:
- Created a loopback image file using `fallocate`:
  ```bash
Commands used
fallocate -l 100M /tmp/inode_test.img
mkfs.ext4 -N 500 /tmp/inode_test.img
sudo mount /tmp/inode_test.img /mnt/inode_test
for i in {1..1000}; do touch /mnt/inode_test/file_$i; done
df -i /mnt/inode_test

Outcome:
Inode usage hit 100%.
System denied new file creation (Permission denied), simulating a real-world issue.
Demonstrated how limited inodes—not disk size—can cripple a file system.

Cleanup:
sudo umount /mnt/inode_test
sudo rm -rf /mnt/inode_test
rm /tmp/inode_test.img
🧾 Filesystem Health & Quota Simulation Report
📘 Scenario
Simulate inode exhaustion and enforce user-level quotas to better understand how storage limitations affect system behavior, especially in shared environments.
🛠️ Setup Overview
1. Created a 100MB loopback device:
bash
fallocate -l 100M /tmp/quota_test.img
2. Formatted with ext4 and limited inodes:
bash
mkfs.ext4 -N 512 -O quota /tmp/quota_test.img
3. Mounted with usrquota option:
bash
sudo mount -o loop,usrquota /tmp/quota_test.img /mnt/quota_test
4. Verified mount and file system support:
bash
mount | grep quota_test
🧪 Inode Exhaustion Simulation
Created many small files until the inode limit was reached:
bash
for i in {1..600}; do touch /mnt/quota_test/file_$i; done
✅ Result: Inodes were exhausted before storage capacity ran out, demonstrating that file count limits can be just as critical as disk size.

📏 User Quota Enforcement
Enabled quota support:
bash
sudo quotacheck -cum /mnt/quota_test
Attempted to enable quotas:
bash
sudo quotaon /mnt/quota_test
Verified active quotas:
bash
sudo repquota /mnt/quota_test

📉 Report Output:
User root had a soft limit of 2 files, which was hit during testing.
Block grace and inode grace time were both set to 7 days by default.

🔍 Key Takeaways
Inode limits are easy to hit in file-heavy environments, even if disk space remains.
User quotas are essential for managing fair usage across shared systems.
Quota setup requires explicit support during formatting (-O quota) and correct mount options.
 ICMP Block Simulation Benchmark Report

**Project Title:** ICMP Echo Request Blocking using `sysctl` and `firewalld`  
**Date:** July 27, 2025  
**Test Engineer:** Dominique Cargle  
**Environment:** Ubuntu on EC2 instance (Amazon Linux 2 VM)  
**Firewall Manager:** `firewalld`  
**Network Tool Used:** `ping` (ICMP echo requests)  

---
## scenario
To validate whether blocking ICMP echo requests via `firewalld` and/or `sysctl` effectively prevents the instance from receiving and responding to ping traffic. Additionally, to explore zone-level blocking using `firewalld` and test inversion functionality.

---
## Methodology

### Baseline Test

| Action                     | Expected Outcome         | Actual Outcome          |
|---------------------------|--------------------------|--------------------------|
| `ping -c 3 <instance>`     | 3 packets transmitted     | 3 received, 0% loss       |
| Firewall baseline rules    | Allow ICMP traffic       | Confirmed enabled         |

### Attempted Blocking via `firewalld`

| Command                                                                 | Result              | Ping Response |
|-------------------------------------------------------------------------|---------------------|---------------|
| `sudo firewall-cmd --add-icmp-block=echo-request`                      | Success/Warning     | Ping **succeeded** |
| `sudo firewall-cmd --reload`                                           | Success             | Ping **succeeded** |
| `sudo firewall-cmd --zone=public --change-interface=eth-test`         | Success             | Ping **succeeded** |
| `sudo firewall-cmd --zone=public --add-icmp-block-inversion`          | Success             | Ping **succeeded** |

### `sysctl` Attempt (Not run due to restrictions on instructor's shell)

| Command                                      | Status       | Comment |
|---------------------------------------------|--------------|---------|
| `echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all` | *Not Executed* | Needs instructor permission |
---
## Observations

- **Ping test consistently passed** despite rules being applied successfully, suggesting either:  
  a) The `firewalld` rules were not applied to the correct interface/zone  
  b) Additional `sysctl` or lower-level kernel configs override the block  
  c) The test environment (instructor’s shell) may have limited permissions  

- **Firewall zones** showed `public (default)`, but additional interface configurations (like `eth0`) may require separate handling or zone assignment.

- **`icmp-block-inversion`** command was accepted, but did not produce observable behavior changes.
---
## Conclusion

The instance did not successfully block ICMP echo requests during the project window. All firewall rules were applied and verified, but no impact was observed. Additional steps (e.g., validating the interface-zone mapping or trying the same on a personal EC2 instance) are needed for full isolation and successful blocking.
---
## Next Steps

- [ ] Replicate this setup on a personal EC2 instance with full control  
- [ ] Retry `sysctl` commands directly on the VM  
- [ ] Consider using `iptables` or `nftables` for more granular control  
- [ ] Capture Wireshark or tcpdump traces to verify incoming ICMP behavior  
- [ ] Document working solution in updated report

