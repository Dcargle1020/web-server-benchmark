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
