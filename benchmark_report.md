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
