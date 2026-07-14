# Troubleshooting — {Server Name}

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Terakhir diperbarui:** {YYYY-MM-DD}

---

## Overview

{Jelaskan pendekatan troubleshooting di server ini}

Contoh:
File ini berisi **common issues** dan solusinya yang pernah terjadi di server ini. Setiap issue didokumentasikan dengan symptoms, root cause, dan solution untuk mempercepat resolusi masalah di masa depan.

---

## Quick Diagnostics

### System Health Check

```bash
# Run comprehensive health check
/opt/docs/health-check.sh

# Quick system overview
echo "=== Uptime ===" && uptime
echo "=== Memory ===" && free -h
echo "=== Disk ===" && df -h /
echo "=== Docker ===" && docker ps --format "table {{.Names}}\t{{.Status}}"
echo "=== Load ===" && top -bn1 | head -5
```

### Check Service Status

```bash
# Nginx
sudo systemctl status nginx
sudo nginx -t

# Docker
docker ps
docker stats --no-stream

# Application
curl -f http://127.0.0.1:{port}/health
docker logs --tail 50 {container_name}
```

---

## Common Issues

### Issue: Container Won't Start

**Symptoms:**
- Container exits immediately after start
- `docker ps` doesn't show container
- Error: "Container exited with code 1"

**Diagnosis:**
```bash
# Check container logs
docker logs {container_name}

# Check container exit code
docker inspect {container_name} | grep -i exitcode

# Start in foreground for debugging
docker compose up
```

**Common Causes & Solutions:**

| Cause | Solution |
|-------|----------|
| Port already in use | Check with `ss -tlnp \| grep {port}`, kill process or change port |
| Missing environment variable | Check `.env` file, add missing variable |
| Database connection failed | Verify DB credentials, check DB server status |
| Permission denied | Check volume mount permissions, fix with `chmod/chown` |
| Out of memory | Increase memory limit in docker-compose.yml |

**Solution Example:**
```bash
# Kill process using port
sudo lsof -ti:{port} | xargs kill -9

# Fix volume permissions
sudo chown -R 1000:1000 /opt/{app_name}/storage

# Increase memory limit
nano /opt/{app_name}/docker-compose.yml
# Change: mem_limit: 2g → mem_limit: 4g
docker compose up -d
```

---

### Issue: High CPU Usage

**Symptoms:**
- System slow/unresponsive
- `uptime` shows high load average
- `top` shows high CPU%

**Diagnosis:**
```bash
# Check system CPU
top -bn1 | head -20

# Check Docker container CPU
docker stats --no-stream

# Check specific process
ps aux | grep {process_name}

# Check for runaway processes
ps aux --sort=-%cpu | head -10
```

**Common Causes & Solutions:**

| Cause | Solution |
|-------|----------|
| Runaway process | Kill process: `kill -9 {pid}` |
| Infinite loop in code | Fix code bug, redeploy |
| Too many workers | Reduce worker count in config |
| Malware/cryptominer | Scan with `rkhunter`, `clamav` |
| Insufficient resources | Scale up server or add more instances |

**Solution Example:**
```bash
# Kill runaway process
sudo kill -9 {pid}

# Restart container with lower resource usage
cd /opt/{app_name}
docker compose down
# Edit docker-compose.yml to reduce workers
docker compose up -d

# Monitor after fix
watch -n 1 'docker stats --no-stream'
```

---

### Issue: High Memory Usage

**Symptoms:**
- System slow, swapping
- `free -h` shows low available memory
- OOM killer terminates processes

**Diagnosis:**
```bash
# Check memory usage
free -h

# Check Docker memory
docker stats --no-stream

# Check memory by process
ps aux --sort=-%mem | head -10

# Check for memory leaks
docker exec {container_name} {memory_profiling_command}
```

**Common Causes & Solutions:**

| Cause | Solution |
|-------|----------|
| Memory leak in application | Fix leak, restart container |
| Too many connections | Increase connection pool size or optimize queries |
| Large cache | Reduce cache size or add more memory |
| Insufficient container limit | Increase mem_limit in docker-compose.yml |
| Too many containers | Remove unused containers, consolidate services |

**Solution Example:**
```bash
# Clear system cache
sudo sync; echo 3 | sudo tee /proc/sys/vm/drop_caches

# Restart container to free memory
docker restart {container_name}

# Increase memory limit
nano /opt/{app_name}/docker-compose.yml
# Change: mem_limit: 2g → mem_limit: 4g
docker compose up -d

# Check for memory leaks
docker exec {container_name} php -d xdebug.mode=profile /path/to/script.php
```

---

### Issue: Disk Full

**Symptoms:**
- "No space left on device" errors
- Applications crash or fail to write
- `df -h` shows 100% usage

**Diagnosis:**
```bash
# Check disk usage
df -h

# Find large files
du -sh /* | sort -hr | head -20

# Find large directories
du -sh /var/log /opt /tmp | sort -hr

# Find old log files
find /var/log -name "*.gz" -mtime +30

# Check Docker disk usage
docker system df
```

**Common Causes & Solutions:**

| Cause | Solution |
|-------|----------|
| Old log files | Rotate/compress logs, delete old ones |
| Docker images/containers | Run `docker system prune` |
| Backup files | Delete old backups, move to remote storage |
| Temporary files | Clear /tmp, application temp files |
| Database growth | Archive old data, optimize tables |

**Solution Example:**
```bash
# Clean old logs
sudo find /var/log -name "*.gz" -mtime +30 -delete
sudo journalctl --vacuum-time=7d

# Clean Docker
docker system prune -af --volumes

# Clean old backups
find /opt/backups -name "*.tar.gz" -mtime +30 -delete

# Clear temp files
sudo rm -rf /tmp/*
sudo rm -rf /opt/{app_name}/storage/framework/cache/*

# Check disk after cleanup
df -h
```

---

### Issue: Database Connection Failed

**Symptoms:**
- Application error: "Connection refused"
- "Too many connections" error
- Slow database queries

**Diagnosis:**
```bash
# Test database connection
mysql -h {db_host} -u {user} -p -e "SELECT 1;"

# Check database status
systemctl status mysql  # or postgresql

# Check active connections
mysql -e "SHOW STATUS LIKE 'Threads_connected';"

# Check for slow queries
mysql -e "SHOW PROCESSLIST;"

# Check database logs
tail -f /var/log/mysql/error.log
```

**Common Causes & Solutions:**

| Cause | Solution |
|-------|----------|
| Database server down | Start/restart database service |
| Wrong credentials | Verify .env file, update credentials |
| Max connections reached | Increase max_connections, optimize queries |
| Firewall blocking | Check firewall rules, allow port |
| Network issue | Ping database server, check routing |

**Solution Example:**
```bash
# Restart database
sudo systemctl restart mysql

# Increase max connections
sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
# Change: max_connections = 151 → max_connections = 500
sudo systemctl restart mysql

# Kill long-running queries
mysql -e "SHOW PROCESSLIST;" | grep -v Sleep | awk '{print $1}' | xargs -I {} mysql -e "KILL {};"

# Check connection from container
docker exec {container_name} mysql -h {db_host} -u {user} -p -e "SELECT 1;"
```

---

### Issue: Nginx 502 Bad Gateway

**Symptoms:**
- Users see "502 Bad Gateway" error
- Nginx error log shows "upstream prematurely closed connection"
- Backend application not responding

**Diagnosis:**
```bash
# Check Nginx status
sudo systemctl status nginx

# Check Nginx error log
tail -f /var/log/nginx/error.log

# Test Nginx configuration
sudo nginx -t

# Check if backend is running
docker ps | grep {container_name}
curl -f http://127.0.0.1:{backend_port}/health

# Check backend logs
docker logs --tail 100 {container_name}
```

**Common Causes & Solutions:**

| Cause | Solution |
|-------|----------|
| Backend container down | Restart container |
| Backend overloaded | Scale up, add more instances |
| Wrong upstream configuration | Fix nginx.conf upstream block |
| Timeout too short | Increase proxy_read_timeout |
| Backend crashing | Check application logs, fix errors |

**Solution Example:**
```bash
# Restart backend container
cd /opt/{app_name}
docker compose restart

# Check if backend responds
curl -I http://127.0.0.1:{backend_port}

# Increase timeout in nginx
sudo nano /etc/nginx/sites-available/{app_name}
# Add: proxy_read_timeout 300;
sudo nginx -t
sudo systemctl reload nginx

# Scale backend (if using multiple instances)
docker compose up -d --scale app=3
```

---

### Issue: SSL Certificate Errors

**Symptoms:**
- Browser shows "Your connection is not private"
- Certificate expired warning
- SSL handshake errors

**Diagnosis:**
```bash
# Check certificate expiry
sudo openssl x509 -in /etc/ssl/certs/{domain}.crt -noout -dates

# Check certificate chain
openssl s_client -connect {domain}:443 -showcerts

# Check Nginx SSL configuration
sudo nginx -t

# Test SSL connection
curl -vI https://{domain}
```

**Common Causes & Solutions:**

| Cause | Solution |
|-------|----------|
| Certificate expired | Renew certificate |
| Wrong certificate path | Fix path in nginx.conf |
| Incomplete certificate chain | Add intermediate certificates |
| Mixed content | Fix HTTP resources on HTTPS page |
| Certificate mismatch | Ensure certificate matches domain |

**Solution Example:**
```bash
# Renew Let's Encrypt certificate
sudo certbot renew

# Or manually renew
sudo certbot certonly --nginx -d {domain}

# Restart Nginx after renewal
sudo systemctl reload nginx

# Verify new certificate
curl -I https://{domain} | grep -i ssl
openssl s_client -connect {domain}:443 | grep "subject\|issuer"
```

---

### Issue: Application Errors (5xx)

**Symptoms:**
- Users see 500/502/503/504 errors
- Application logs show errors
- Monitoring alerts for high error rate

**Diagnosis:**
```bash
# Check application logs
docker logs --tail 200 {container_name} | grep -i error

# Check Nginx error log
tail -f /var/log/nginx/error.log

# Check for specific error patterns
docker logs {container_name} | grep -E "(Fatal|Exception|Error)" | tail -50

# Test application directly
curl -f http://127.0.0.1:{port}/health
```

**Common Causes & Solutions:**

| Cause | Solution |
|-------|----------|
| Application bug | Fix code, redeploy |
| Missing dependency | Install dependency, rebuild image |
| Configuration error | Fix config file, restart |
| Database error | Check DB connection, fix queries |
| Out of resources | Increase memory/CPU limits |

**Solution Example:**
```bash
# Check specific error
docker logs {container_name} | grep -A 5 "Fatal error"

# Restart application
docker restart {container_name}

# Rebuild with fixes
cd /opt/{app_name}
git pull origin main
docker compose build
docker compose up -d

# Monitor after fix
docker logs -f {container_name}
```

---

### Issue: Slow Response Time

**Symptoms:**
- Pages load slowly (> 2 seconds)
- High latency in monitoring
- User complaints about performance

**Diagnosis:**
```bash
# Test response time
curl -w "@curl-format.txt" -o /dev/null -s https://{domain}

# Check system resources
top
docker stats --no-stream

# Check database slow queries
mysql -e "SHOW PROCESSLIST;" | grep -v Sleep

# Check application logs for slow operations
docker logs {container_name} | grep -E "(slow|timeout|took [0-9]+ms)"

# Profile application
docker exec {container_name} {profiling_command}
```

**Common Causes & Solutions:**

| Cause | Solution |
|-------|----------|
| Slow database queries | Add indexes, optimize queries |
| No caching | Enable Redis/Memcached caching |
| Large payloads | Compress responses, paginate results |
| Insufficient resources | Scale up CPU/memory |
| Network latency | Use CDN, optimize assets |

**Solution Example:**
```bash
# Enable query caching
mysql -e "SET GLOBAL query_cache_size = 67108864;"

# Add database index
mysql -e "CREATE INDEX idx_user_email ON users(email);"

# Enable application caching
# Edit config to enable Redis cache
docker exec {container_name} php artisan config:cache
docker exec {container_name} php artisan route:cache

# Compress responses
# Add to nginx.conf:
# gzip on;
# gzip_types text/plain application/json;
sudo systemctl reload nginx
```

---

## Emergency Procedures

### Service Down - Quick Recovery

```bash
# 1. Check what's down
docker ps
sudo systemctl status nginx

# 2. Restart services
sudo systemctl restart nginx
cd /opt/{app_name} && docker compose restart

# 3. Verify recovery
docker ps
curl -f http://127.0.0.1:{port}/health

# 4. Check logs for root cause
docker logs {container_name} | tail -100
```

### High Load - Emergency Mitigation

```bash
# 1. Identify top processes
top -bn1 | head -20
docker stats --no-stream

# 2. Kill non-critical processes
sudo kill -9 {non_critical_pid}

# 3. Restart heavy containers
docker restart {heavy_container}

# 4. Scale down if needed
docker compose up -d --scale app=1
```

### Security Incident - Isolation

```bash
# 1. Isolate server (EMERGENCY ONLY)
sudo ufw enable
sudo ufw default deny incoming
sudo ufw allow from {admin_ip} to any port 22

# 2. Kill suspicious processes
sudo ps aux | grep suspicious
sudo kill -9 {suspicious_pid}

# 3. Block suspicious IPs
sudo ufw deny from {suspicious_ip}

# 4. Capture forensics
sudo mkdir /tmp/forensics
sudo cp /var/log/* /tmp/forensics/
sudo ps aux > /tmp/forensics/processes.txt
sudo netstat -tulnp > /tmp/forensics/network.txt
```

---

## Diagnostic Tools

### System Tools

```bash
# CPU/Memory/Disk
htop
iotop
iostat -x 1 5
vmstat 1 5

# Network
iftop
nload
ss -tulnp
tcpdump -i eth0

# Processes
ps aux
lsof
strace -p {pid}
```

### Docker Tools

```bash
# Container inspection
docker inspect {container_name}
docker stats
docker top {container_name}

# Logs
docker logs -f {container_name}
docker logs --since 1h {container_name}

# Debugging
docker exec -it {container_name} sh
docker exec {container_name} {debug_command}
```

### Application Tools

```bash
# Laravel
docker exec {container_name} php artisan route:list
docker exec {container_name} php artisan config:show
docker exec {container_name} php artisan queue:failed

# Node.js
docker exec {container_name} npm list
docker exec {container_name} node --inspect

# Database
docker exec {db_container} mysql -e "SHOW PROCESSLIST;"
docker exec {db_container} mysql -e "SHOW STATUS;"
```

---

## Log Analysis

### Common Log Patterns

```bash
# Find errors
grep -i "error\|exception\|fatal" /var/log/nginx/error.log
docker logs {container_name} | grep -i error

# Find slow requests
grep -E "took [0-9]{4,}ms" /opt/{app_name}/logs/app.log

# Find security issues
grep -E "(SQL injection|XSS|CSRF)" /var/log/nginx/access.log

# Find 5xx errors
grep " 5[0-9][0-9] " /var/log/nginx/access.log
```

### Log Rotation Issues

```bash
# Check logrotate status
cat /var/lib/logrotate/status

# Force log rotation
sudo logrotate -f /etc/logrotate.d/nginx

# Check logrotate errors
sudo logrotate -d /etc/logrotate.conf
```

---

## Performance Tuning

### Quick Wins

```bash
# Clear system cache
sudo sync; echo 3 | sudo tee /proc/sys/vm/drop_caches

# Clear application cache
docker exec {container_name} php artisan cache:clear
docker exec {container_name} php artisan config:clear

# Optimize database
docker exec {db_container} mysqlcheck -o --all-databases

# Restart services
sudo systemctl restart nginx
docker compose restart
```

### Long-term Solutions

- Add more RAM or CPU
- Implement caching (Redis, CDN)
- Optimize database queries
- Use connection pooling
- Implement horizontal scaling
- Upgrade to faster storage (SSD)

---

## When to Escalate

### Escalate to DevOps Lead

- Infrastructure issues (network, storage, compute)
- Security incidents or breaches
- Performance degradation affecting users
- Failed deployments or rollbacks
- Backup/recovery failures

### Escalate to Backend Lead

- Application bugs or crashes
- Database issues or data corruption
- API errors or integration failures
- Performance issues in application code

### Escalate to System Admin

- OS-level issues (kernel, drivers)
- Hardware failures
- Network connectivity issues
- DNS or certificate issues

---

## Prevention

### Regular Maintenance

```bash
# Weekly
- Review logs for errors
- Check disk space and growth
- Test backups
- Update dependencies

# Monthly
- Security audit
- Performance review
- Capacity planning
- Disaster recovery test

# Quarterly
- Penetration testing
- Full system review
- Documentation update
- Training and knowledge sharing
```

### Monitoring Alerts

Set up alerts for:
- High CPU/Memory/Disk usage
- Service downtime
- High error rates
- Slow response times
- Certificate expiry
- Backup failures
- Security incidents

---

## Contributing to This Document

When you resolve a new issue, please add it to this document:

1. **Describe symptoms** clearly
2. **List diagnostic steps** you took
3. **Explain root cause**
4. **Provide solution** with commands
5. **Add prevention tips** if applicable

This helps the team resolve similar issues faster in the future.

---

**Last Updated:** {YYYY-MM-DD}
**Maintained by:** DevOps Team
