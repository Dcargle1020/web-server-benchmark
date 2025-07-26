# Web Server Benchmark

This project benchmarks the performance of three web servers: **Apache**, **NGINX**, and **Lighttpd** under minimal load.

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

> This lab was completed on an AWS EC2 instance running Ubuntu 24.04.
# Web Server Benchmark
