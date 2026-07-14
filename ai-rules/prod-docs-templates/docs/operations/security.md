# Security — {Server Name}

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Terakhir diperbarui:** {YYYY-MM-DD}

---

## Overview

{Jelaskan security posture dan hardening yang diterapkan di server ini}

Contoh:
Server ini mengikuti **security best practices** dengan defense-in-depth approach. Hardening dilakukan di semua layer: network, OS, application, dan container. Regular security audits dilakukan setiap {frequency}.

---

## Security Layers

| Layer | Measures |
|-------|----------|
| **Network** | Firewall, private network, VPN, DDoS protection |
| **OS** | Minimal packages, automatic updates, file permissions |
| **SSH** | Key-only auth, no root login, fail2ban |
| **Application** | Input validation, CSRF protection, rate limiting |
| **Container** | Hardened images, resource limits, no root |
| **Data** | Encryption at rest, TLS in transit, backup encryption |
| **Monitoring** | Intrusion detection, log analysis, alerting |

---

## Network Security

### Firewall (UFW)

```bash
# Check status
sudo ufw status verbose

# Active rules
sudo ufw status numbered

# Default policy
sudo ufw default deny incoming
sudo ufw default allow outgoing
```

### Allowed Ports

| Port | Protocol | Source | Purpose |
|------|----------|--------|---------|
| 22 | TCP | {admin_ips} | SSH access |
| 80 | TCP | Load Balancer | HTTP |
| 443 | TCP | Load Balancer | HTTPS |

### Intrusion Prevention (Fail2ban)

```bash
# Check status
sudo fail2ban-client status

# Check SSH jail
sudo fail2ban-client status sshd

# View banned IPs
sudo fail2ban-client get sshd banned

# Unban IP
sudo fail2ban-client set sshd unbanip {ip_address}
```

**Configuration:** `/etc/fail2ban/jail.local`

```ini
[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600
findtime = 600
```

---

## SSH Security

### Configuration

```bash
# /etc/ssh/sshd_config
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
MaxAuthTries 3
LoginGraceTime 30
AllowUsers {allowed_users}
AllowTcpForwarding no
X11Forwarding no
```

### SSH Key Management

```bash
# Add new SSH key
echo "{public_key}" >> ~/.ssh/authorized_keys

# List authorized keys
cat ~/.ssh/authorized_keys

# Remove key (edit file)
nano ~/.ssh/authorized_keys

# Key permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

### SSH Access Log

```bash
# View SSH login attempts
sudo grep "sshd" /var/log/auth.log

# Failed login attempts
sudo grep "Failed password" /var/log/auth.log

# Successful logins
sudo grep "Accepted" /var/log/auth.log
```

---

## Container Security

### Docker Hardening

```yaml
# docker-compose.yml security settings
services:
  app:
    # Drop all capabilities
    cap_drop:
      - ALL
    
    # Add only necessary capabilities
    cap_add:
      - NET_BIND_SERVICE
    
    # Prevent privilege escalation
    security_opt:
      - no-new-privileges:true
    
    # Read-only filesystem
    read_only: true
    tmpfs:
      - /tmp
      - /var/tmp
    
    # Resource limits
    deploy:
      resources:
        limits:
          cpus: '2.0'
          memory: 2G
          pids: 100
    
    # Run as non-root
    user: "1000:1000"
    
    # Security context
    security_opt:
      - apparmor:docker-default
      - seccomp:default
```

### Container Scanning

```bash
# Scan image for vulnerabilities
docker scout cves {image_name}:{tag}

# Alternative: Trivy
trivy image {image_name}:{tag}

# Check for outdated packages
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image {image_name}:{tag}
```

### Container Isolation

```bash
# List container networks
docker network ls

# Inspect network
docker network inspect {network_name}

# Check container isolation
docker inspect {container_name} | grep -A 10 "NetworkSettings"
```

---

## Application Security

### Web Application Firewall (WAF)

{Jelaskan jika menggunakan WAF}

Contoh:
- **ModSecurity**: Open-source WAF dengan OWASP Core Rule Set
- **Cloudflare WAF**: Cloud-based WAF dengan custom rules
- **AWS WAF**: Managed WAF service

### Security Headers (Nginx)

```nginx
# /etc/nginx/snippets/security-headers.conf
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header Referrer-Policy "strict-origin-when-cross-origin" always;
add_header Content-Security-Policy "default-src 'self'" always;
add_header Permissions-Policy "geolocation=(), microphone=(), camera=()" always;
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
```

### Rate Limiting

```nginx
# /etc/nginx/nginx.conf
# Define rate limit zone
limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;
limit_req_zone $binary_remote_addr zone=login:10m rate=5r/m;

# Apply rate limit
location /api/ {
    limit_req zone=api burst=20 nodelay;
    proxy_pass http://backend;
}

location /login {
    limit_req zone=login burst=3 nodelay;
    proxy_pass http://backend;
}
```

### CORS Configuration

```nginx
# Allow specific origins only
location /api/ {
    if ($request_method = 'OPTIONS') {
        add_header 'Access-Control-Allow-Origin' 'https://{domain}';
        add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, DELETE';
        add_header 'Access-Control-Allow-Headers' 'Authorization, Content-Type';
        add_header 'Access-Control-Max-Age' 1728000;
        return 204;
    }
    
    add_header 'Access-Control-Allow-Origin' 'https://{domain}' always;
    add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, DELETE' always;
    add_header 'Access-Control-Allow-Headers' 'Authorization, Content-Type' always;
    
    proxy_pass http://backend;
}
```

---

## Data Security

### Encryption at Rest

```bash
# Encrypt file
gpg --symmetric --cipher-algo AES256 sensitive-file.txt

# Decrypt file
gpg --decrypt sensitive-file.txt.gpg > sensitive-file.txt

# Encrypt backup
tar -czf - /opt/{app_name} | gpg --symmetric --cipher-algo AES256 > backup.tar.gz.gpg
```

### Encryption in Transit

```bash
# Check SSL/TLS configuration
openssl s_client -connect {domain}:443 -tls1_2
openssl s_client -connect {domain}:443 -tls1_3

# Test SSL configuration
curl -I https://{domain} --tlsv1.2
curl -I https://{domain} --tlsv1.3
```

### Secrets Management

```bash
# Environment file permissions
chmod 600 /opt/{app_name}/.env
chown root:root /opt/{app_name}/.env

# List secrets in environment
grep -E "(PASSWORD|SECRET|KEY|TOKEN)" /opt/{app_name}/.env

# Rotate secrets
nano /opt/{app_name}/.env
# Update value
docker compose -f /opt/{app_name}/docker-compose.yml up -d
```

### Database Security

```bash
# Check MySQL user privileges
mysql -u root -p -e "SELECT User, Host FROM mysql.user;"

# Remove anonymous users
mysql -u root -p -e "DELETE FROM mysql.user WHERE User='';"

# Remove test database
mysql -u root -p -e "DROP DATABASE IF EXISTS test;"

# Check for weak passwords
mysql -u root -p -e "SELECT User, Host, authentication_string FROM mysql.user;"
```

---

## Access Control

### User Management

```bash
# List users
cat /etc/passwd | grep -E "/bin/(bash|sh)$"

# List sudo users
cat /etc/group | grep sudo

# Add user
sudo adduser {username}

# Add to sudo group
sudo usermod -aG sudo {username}

# Remove user
sudo deluser {username}
```

### File Permissions

```bash
# Check permissions
ls -la /opt/{app_name}

# Set ownership
chown -R root:root /opt/{app_name}
chown -R www-data:www-data /opt/{app_name}/storage

# Set permissions
chmod -R 755 /opt/{app_name}
chmod -R 644 /opt/{app_name}/.env

# Find world-writable files
find /opt -type f -perm -002

# Find SUID files
find / -perm -4000 -type f
```

### Application Permissions

```bash
# Check container user
docker exec {container_name} id

# Check file ownership in container
docker exec {container_name} ls -la /var/www/html

# Check volume permissions
docker exec {container_name} ls -la /var/www/html/storage
```

---

## Vulnerability Management

### System Updates

```bash
# Check for updates
sudo apt update
apt list --upgradable

# Apply security updates only
sudo apt-get upgrade -s | grep -i security
sudo unattended-upgrade

# Apply all updates
sudo apt upgrade -y

# Reboot if kernel updated
[ -f /var/run/reboot-required ] && sudo reboot
```

### Automatic Updates

```bash
# /etc/apt/apt.conf.d/20auto-upgrades
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
```

### Dependency Scanning

```bash
# Node.js dependencies
cd /opt/{app_name}
npm audit

# Python dependencies
pip-audit

# PHP dependencies
composer audit

# Go dependencies
govulncheck ./...
```

---

## Security Auditing

### Security Checklist

- [ ] Firewall configured correctly
- [ ] SSH hardened (key-only, no root)
- [ ] Fail2ban active
- [ ] Automatic updates enabled
- [ ] Containers hardened
- [ ] Secrets encrypted and rotated
- [ ] SSL/TLS properly configured
- [ ] Security headers enabled
- [ ] Rate limiting configured
- [ ] Backups encrypted
- [ ] Logs monitored
- [ ] Intrusion detection active

### Security Scanning Tools

```bash
# Lynis - System audit
sudo lynis audit system

# OpenSCAP - Compliance check
oscap xccdf eval --profile xccdf_org.ssgproject.content_profile_standard /usr/share/xml/scap/ssg/content/ssg-ubuntu2204-ds.xml

# CIS Benchmark
# Download from: https://www.cisecurity.org/cis-benchmarks
```

### Penetration Testing

{Jelaskan penetration testing yang dilakukan}

Contoh:
- **Internal**: Quarterly security review by DevOps team
- **External**: Annual penetration test by third-party security firm
- **Continuous**: Automated security scanning in CI/CD pipeline

---

## Incident Response

### Security Incident Checklist

1. **Detect**: Identify the incident from logs/alerts
2. **Contain**: Isolate affected systems
3. **Eradicate**: Remove threat and patch vulnerability
4. **Recover**: Restore from clean backup
5. **Learn**: Document incident and improve defenses

### Emergency Contacts

| Role | Contact | When to Call |
|------|---------|--------------|
| Security Lead | {contact} | Security incidents, breaches |
| DevOps Lead | {contact} | Infrastructure compromise |
| Legal | {contact} | Data breach, compliance issues |
| PR | {contact} | Public disclosure needed |

### Incident Response Commands

```bash
# Isolate server (emergency only)
sudo ufw enable
sudo ufw default deny incoming
sudo ufw allow from {admin_ip} to any port 22

# Kill suspicious process
sudo kill -9 {pid}

# Block IP
sudo ufw deny from {suspicious_ip}

# Capture forensic data
sudo mkdir /tmp/forensics
sudo cp /var/log/* /tmp/forensics/
sudo ps aux > /tmp/forensics/processes.txt
sudo netstat -tulnp > /tmp/forensics/network.txt
```

---

## Compliance

### Data Protection (GDPR)

{Jelaskan GDPR compliance measures}

- Data encrypted at rest and in transit
- Right to erasure implemented
- Data breach notification procedure (< 72 hours)
- Data processing agreements with vendors
- Privacy policy and cookie notice

### PCI DSS (if handling payments)

{Jelaskan PCI DSS compliance jika applicable}

- Cardholder data encrypted
- Network segmentation
- Regular security testing
- Access control and monitoring
- Vulnerability management program

---

## Security Monitoring

### Log Analysis

```bash
# Failed login attempts
sudo grep "Failed password" /var/log/auth.log | tail -20

# Suspicious activity
sudo grep "sudo:" /var/log/auth.log | grep -v "{admin_user}"

# Web application attacks
grep -E "(SELECT|UNION|DROP|INSERT|UPDATE|DELETE)" /var/log/nginx/access.log

# Port scanning
sudo grep "refused connect" /var/log/syslog
```

### Intrusion Detection

```bash
# Check for rootkits
sudo rkhunter --check

# Check for malware
sudo clamscan -r /opt

# Check for unauthorized changes
sudo aide --check

# Monitor file integrity
sudo auditctl -w /etc/passwd -p wa -k passwd_changes
```

---

## Security Best Practices

### DO

- ✅ Use strong, unique passwords
- ✅ Enable 2FA for all accounts
- ✅ Keep all software updated
- ✅ Encrypt sensitive data
- ✅ Monitor logs regularly
- ✅ Backup data regularly
- ✅ Test backups regularly
- ✅ Use principle of least privilege
- ✅ Segment networks
- ✅ Audit access regularly

### DON'T

- ❌ Use default passwords
- ❌ Share credentials
- ❌ Disable security features
- ❌ Run as root unnecessarily
- ❌ Expose unnecessary ports
- ❌ Store secrets in code
- ❌ Ignore security alerts
- ❌ Skip security updates
- ❌ Use outdated software
- ❌ Grant excessive permissions

---

**Last Updated:** {YYYY-MM-DD}
**Maintained by:** DevOps + Security Team
