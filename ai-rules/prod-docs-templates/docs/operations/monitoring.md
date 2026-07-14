# Monitoring & Logging — {Server Name}

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Terakhir diperbarui:** {YYYY-MM-DD}

---

## Overview

{Jelaskan strategi monitoring dan logging yang digunakan di server ini}

Contoh:
Server ini menggunakan **centralized logging** dengan semua container logs di-collect ke host. Monitoring dilakukan via **Prometheus + Grafana** untuk metrics dan **custom dashboards** untuk application health. Alerts dikirim via {email/Slack/PagerDuty} untuk critical issues.

---

## Monitoring Stack

| Component | Technology | Purpose |
|-----------|-----------|---------|
| Metrics Collection | {Prometheus/Telegraf} | Collect system and application metrics |
| Visualization | {Grafana} | Dashboards and graphs |
| Alerting | {Alertmanager/PagerDuty} | Notifications for issues |
| Log Aggregation | {ELK/Loki} | Centralized log storage |
| Uptime Monitoring | {UptimeRobot/Pingdom} | External health checks |

---

## Metrics

### System Metrics

```bash
# CPU, Memory, Disk
htop
free -h
df -h
iostat -x 1 5

# Network
iftop
nload
ss -s
```

### Docker Metrics

```bash
# Container resource usage
docker stats

# Container information
docker ps
docker inspect {container_name}

# Docker system
docker system df
docker system events
```

### Application Metrics

{Jelaskan metrics spesifik aplikasi yang dimonitor}

Contoh:
- **Response Time**: Average, P95, P99
- **Error Rate**: 4xx, 5xx errors per minute
- **Throughput**: Requests per second
- **Active Connections**: Current connections to app
- **Queue Length**: Jobs waiting in queue

### Custom Metrics Endpoint

```bash
# Prometheus metrics endpoint
curl http://127.0.0.1:{port}/metrics

# Example metrics
# HELP http_requests_total Total number of HTTP requests
# TYPE http_requests_total counter
http_requests_total{method="GET",status="200"} 1234
http_requests_total{method="POST",status="201"} 567
```

---

## Logging

### Log Locations

| Service | Log Location | Rotation |
|---------|--------------|----------|
| Nginx Access | `/var/log/nginx/access.log` | Daily, 14 days |
| Nginx Error | `/var/log/nginx/error.log` | Daily, 14 days |
| {app_1} | `/opt/{app_1}/logs/app.log` | Daily, 30 days |
| {app_2} | `/opt/{app_2}/logs/app.log` | Daily, 30 days |
| Docker | `docker logs {container}` | Container logs |
| System | `/var/log/syslog` | Weekly, 4 weeks |
| Backup | `/var/log/backup.log` | Monthly, 12 months |

### View Logs

```bash
# Real-time logs
tail -f /var/log/nginx/access.log
docker logs -f {container_name}

# Last 100 lines
tail -100 /var/log/nginx/error.log
docker logs --tail 100 {container_name}

# Logs from specific time
docker logs --since 1h {container_name}
docker logs --since "2026-06-09T10:00:00" {container_name}

# Search logs
grep "ERROR" /opt/{app_name}/logs/app.log
docker logs {container_name} 2>&1 | grep "ERROR"
```

### Log Format

#### Nginx Access Log

```
{client_ip} - - [{timestamp}] "{method} {path} {protocol}" {status} {bytes} "{referer}" "{user_agent}"
```

Example:
```
192.168.1.100 - - [09/Jun/2026:10:30:45 +0000] "GET /api/users HTTP/1.1" 200 1234 "-" "Mozilla/5.0"
```

#### Application Log (JSON)

```json
{
  "timestamp": "2026-06-09T10:30:45Z",
  "level": "info",
  "message": "User login successful",
  "user_id": 123,
  "ip": "192.168.1.100",
  "duration_ms": 45
}
```

---

## Log Rotation

### Logrotate Configuration

```bash
# /etc/logrotate.d/nginx
/var/log/nginx/*.log {
    daily
    missingok
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 www-data adm
    sharedscripts
    postrotate
        [ -f /var/run/nginx.pid ] && kill -USR1 `cat /var/run/nginx.pid`
    endscript
}
```

```bash
# /etc/logrotate.d/{app_name}
/opt/{app_name}/logs/*.log {
    daily
    missingok
    rotate 30
    compress
    delaycompress
    notifempty
    create 0640 root root
}
```

### Manual Rotation

```bash
# Force rotation
sudo logrotate -f /etc/logrotate.d/nginx

# Check rotation status
cat /var/lib/logrotate/status
```

---

## Alerting

### Alert Rules

{List alert rules yang dikonfigurasi}

| Alert | Condition | Severity | Notification |
|-------|-----------|----------|--------------|
| High CPU | CPU > 90% for 5m | Warning | Slack |
| High Memory | Memory > 85% for 5m | Warning | Slack |
| Disk Full | Disk > 90% | Critical | Email + PagerDuty |
| Service Down | Container not running | Critical | Email + PagerDuty |
| High Error Rate | 5xx > 5% for 5m | Critical | Email + Slack |
| Slow Response | P95 > 2s for 5m | Warning | Slack |
| Certificate Expiring | < 7 days | Warning | Email |

### Prometheus Alert Rules

```yaml
# /etc/prometheus/alerts.yml
groups:
  - name: system
    rules:
      - alert: HighCPU
        expr: 100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 90
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High CPU usage detected"
          
      - alert: HighMemory
        expr: (node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100 > 85
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High memory usage detected"
          
      - alert: DiskFull
        expr: (node_filesystem_size_bytes - node_filesystem_avail_bytes) / node_filesystem_size_bytes * 100 > 90
        labels:
          severity: critical
        annotations:
          summary: "Disk space running low"
```

### Notification Channels

```yaml
# /etc/alertmanager/alertmanager.yml
route:
  receiver: 'default'
  routes:
    - match:
        severity: critical
      receiver: 'pagerduty'
    - match:
        severity: warning
      receiver: 'slack'

receivers:
  - name: 'default'
    email_configs:
      - to: '{email}'
        
  - name: 'slack'
    slack_configs:
      - api_url: '{slack_webhook}'
        channel: '#{channel}'
        
  - name: 'pagerduty'
    pagerduty_configs:
      - service_key: '{pagerduty_key}'
```

---

## Dashboards

### Grafana Dashboards

{List dashboards yang tersedia}

| Dashboard | URL | Purpose |
|-----------|-----|---------|
| System Overview | {url} | CPU, memory, disk, network |
| Docker Containers | {url} | Container metrics |
| Nginx | {url} | Request rate, response time, errors |
| Application | {url} | App-specific metrics |
| Database | {url} | Query performance, connections |

### Custom Dashboard Commands

```bash
# Quick system overview
watch -n 1 'echo "=== CPU ===" && top -bn1 | head -5 && echo && echo "=== Memory ===" && free -h && echo && echo "=== Disk ===" && df -h / && echo && echo "=== Docker ===" && docker stats --no-stream'

# Nginx request rate
tail -f /var/log/nginx/access.log | pv -l -i 1 > /dev/null

# Error rate
tail -f /var/log/nginx/access.log | grep -E " (4|5)[0-9]{2} " | pv -l -i 1 > /dev/null
```

---

## Health Checks

### Application Health

```bash
# Basic health check
curl -f http://127.0.0.1:{port}/health

# Detailed health check
curl -s http://127.0.0.1:{port}/health | jq .

# Check all services
for port in {port1} {port2} {port3}; do
  echo "Checking port $port..."
  curl -f http://127.0.0.1:$port/health && echo "✓ OK" || echo "✗ FAILED"
done
```

### External Health Checks

{Jelaskan external monitoring services}

Contoh:
- **UptimeRobot**: Checks https://{domain} every 5 minutes
- **Pingdom**: Multi-location checks every 1 minute
- **StatusPage**: Public status page at status.{domain}

---

## Troubleshooting with Logs

### Common Log Analysis

```bash
# Find 5xx errors
grep " 5[0-9][0-9] " /var/log/nginx/access.log

# Find slow requests (> 1 second)
awk '$NF > 1' /var/log/nginx/access.log

# Top IP addresses
awk '{print $1}' /var/log/nginx/access.log | sort | uniq -c | sort -rn | head -20

# Top URLs
awk '{print $7}' /var/log/nginx/access.log | sort | uniq -c | sort -rn | head -20

# Error logs
tail -100 /var/log/nginx/error.log | grep -E "(error|crit|alert)"

# Docker container errors
docker logs {container_name} 2>&1 | grep -i error
```

### Log Aggregation

```bash
# Search across all logs
grep -r "ERROR" /var/log/ /opt/*/logs/

# Find logs from specific time
find /var/log /opt/*/logs -name "*.log" -newer /tmp/timestamp

# Combine logs from multiple sources
tail -f /var/log/nginx/access.log /opt/{app_name}/logs/app.log
```

---

## Performance Monitoring

### Resource Usage Over Time

```bash
# CPU usage (1 second intervals)
mpstat 1 10

# Memory usage
watch -n 1 'free -h'

# Disk I/O
iostat -x 1 5

# Network traffic
iftop -i eth0
nload eth0
```

### Docker Performance

```bash
# Container resource usage
docker stats --no-stream

# Container processes
docker top {container_name}

# Docker events
docker events --since 1h
```

### Database Performance

```bash
# Slow queries
mysql -u {user} -p -e "SHOW GLOBAL STATUS LIKE 'Slow_queries';"

# Active connections
mysql -u {user} -p -e "SHOW STATUS LIKE 'Threads_connected';"

# Query performance
mysql -u {user} -p -e "SHOW PROCESSLIST;"
```

---

## Monitoring Scripts

### Quick Health Check

```bash
#!/bin/bash
# /opt/docs/health-check.sh

echo "=== System Health ==="
echo
echo "CPU Load:"
uptime
echo
echo "Memory:"
free -h
echo
echo "Disk:"
df -h /
echo
echo "Docker Containers:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo
echo "Application Health:"
for port in {port1} {port2} {port3}; do
  echo -n "Port $port: "
  curl -f -s http://127.0.0.1:$port/health > /dev/null && echo "✓ OK" || echo "✗ FAILED"
done
```

### Log Summary

```bash
#!/bin/bash
# /opt/docs/log-summary.sh

echo "=== Log Summary (Last Hour) ==="
echo
echo "Nginx Requests:"
tail -n 1000 /var/log/nginx/access.log | grep "$(date -d '1 hour ago' '+%d/%b/%Y:%H')" | wc -l
echo
echo "Nginx Errors:"
tail -n 1000 /var/log/nginx/error.log | grep "$(date -d '1 hour ago' '+%Y/%m/%d %H')" | wc -l
echo
echo "Application Errors:"
grep "$(date -d '1 hour ago' '+%Y-%m-%d %H')" /opt/{app_name}/logs/app.log | grep -i error | wc -l
```

---

## Uptime & SLA

### Current Uptime

```bash
# System uptime
uptime

# Service uptime
systemctl status nginx | grep Active
docker ps --format "{{.Names}}: {{.Status}}"
```

### SLA Targets

| Metric | Target | Current |
|--------|--------|---------|
| Uptime | 99.9% | {current}% |
| Response Time (P95) | < 500ms | {current}ms |
| Error Rate | < 0.1% | {current}% |
| Backup Success | 100% | {current}% |

---

## Maintenance

### Log Cleanup

```bash
# Remove old logs
find /var/log -name "*.gz" -mtime +30 -delete
find /opt/*/logs -name "*.log.*" -mtime +30 -delete

# Truncate large logs
truncate -s 0 /var/log/nginx/access.log
truncate -s 0 /opt/{app_name}/logs/app.log
```

### Monitoring Stack Maintenance

```bash
# Update Prometheus
docker pull prom/prometheus:latest
docker compose -f /opt/monitoring/docker-compose.yml up -d

# Update Grafana
docker pull grafana/grafana:latest
docker compose -f /opt/monitoring/docker-compose.yml up -d

# Backup Grafana dashboards
docker exec grafana grafana-cli admin export all /backup/grafana
```

---

**Last Updated:** {YYYY-MM-DD}
**Maintained by:** DevOps Team
