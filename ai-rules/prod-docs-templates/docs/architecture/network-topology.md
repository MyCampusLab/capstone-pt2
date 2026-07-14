# Network Topology — {Server Name}

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Server:** {hostname}
> **Terakhir diperbarui:** {YYYY-MM-DD}

---

## Network Overview

{Jelaskan topologi jaringan server secara umum}

Contoh:
Server ini berada di **private network** (10.35.4.0/24) di belakang **load balancer** yang melakukan SSL termination. Server hanya menerima traffic HTTP dari load balancer, tidak ada direct internet access ke server.

---

## Network Diagram

```
Internet
    │
    ▼
┌─────────────────────────────────────────┐
│           Load Balancer                 │
│   {lb_ip} (Public)                      │
│   SSL Termination (443 → 80)           │
│   Health Check: /health                 │
└─────────────────────────────────────────┘
    │ HTTP (port 80)
    ▼
┌─────────────────────────────────────────┐
│         Private Network                 │
│         10.35.4.0/24                    │
│                                         │
│  ┌──────────────┐  ┌──────────────┐   │
│  │ App Server   │  │ DB Server    │   │
│  │ 10.35.4.60   │  │ 10.35.4.61   │   │
│  │              │  │              │   │
│  │ Nginx (80)   │  │ MariaDB(3306)│   │
│  │ Docker (9000)│  │ Postgres(5432│   │
│  │ Docker (3000)│  │ Redis (6379) │   │
│  └──────────────┘  └──────────────┘   │
│                                         │
└─────────────────────────────────────────┘
```

---

## IP Addressing

| Server/Service | IP Address | Purpose |
|----------------|------------|---------|
| Load Balancer | {public_ip} | Public endpoint, SSL termination |
| App Server | {app_ip} | Application server (this server) |
| Database Server | {db_ip} | Database servers |
| Backup Server | {backup_ip} | Offsite backup storage |
| Monitoring | {monitoring_ip} | Prometheus + Grafana |

---

## Ports & Services

### Inbound (dari Load Balancer)

| Port | Service | Source | Purpose |
|------|---------|--------|---------|
| 80 | Nginx | Load Balancer | HTTP traffic (after SSL termination) |
| 22 | SSH | {admin_ips} | SSH access (restricted IPs only) |

### Internal (antara services)

| Port | Service | Bind Address | Purpose |
|------|---------|--------------|---------|
| 9000 | {app_1} FPM | 127.0.0.1 | PHP-FPM for {app_1} |
| 3000 | {app_2} | 0.0.0.0 | Node.js app (host network) |
| 3001 | {app_3} | 127.0.0.1 | Analytics app |
| 6379 | Redis | Docker internal | Cache & session |

### Outbound (ke external services)

| Destination | Port | Purpose |
|-------------|------|---------|
| {db_ip} | 3306 | MariaDB connection |
| {db_ip} | 5432 | PostgreSQL connection |
| api.github.com | 443 | Auto-deploy webhook |
| smtp.provider.com | 587 | Email sending |

---

## Firewall Rules

{Jelaskan firewall rules yang diterapkan}

### UFW Status

```bash
sudo ufw status verbose
```

### Active Rules

| Rule | Direction | Port | Source | Action | Purpose |
|------|-----------|------|--------|--------|---------|
| 1 | IN | 22 | {admin_cidr} | ALLOW | SSH access |
| 2 | IN | 80 | {lb_ip} | ALLOW | HTTP from LB |
| 3 | IN | 443 | {lb_ip} | ALLOW | HTTPS from LB |
| 4 | IN | Any | Any | DENY | Default deny |

---

## Docker Networks

| Network | Container | Subnet | Purpose |
|---------|-----------|--------|---------|
| {app_1}-net | {app_1}, redis | 172.20.0.0/16 | Internal {app_1} communication |
| host | {app_2} | Host network | Performance (no NAT overhead) |
| bridge | {app_3} | 172.17.0.0/16 | Default Docker bridge |

---

## DNS Configuration

### Internal DNS

| Hostname | IP | Purpose |
|----------|-----|---------|
| {hostname} | {ip} | This server |
| db.{domain} | {db_ip} | Database server |
| backup.{domain} | {backup_ip} | Backup server |

### External DNS

```bash
cat /etc/resolv.conf
```

---

## SSL/TLS Configuration

{Jelaskan konfigurasi SSL/TLS}

### Certificate Location

```
/etc/ssl/certs/{domain}.crt
/etc/ssl/private/{domain}.key
```

### SSL Termination

SSL termination dilakukan di **Load Balancer**, bukan di Nginx. Nginx hanya menerima HTTP traffic.

Header yang di-forward:
- `X-Forwarded-Proto: https` — Indicate original protocol
- `X-Forwarded-For: {client_ip}` — Original client IP
- `X-Real-IP: {client_ip}` — Real client IP

### Certificate Renewal

{Jelaskan proses renewal certificate}

Contoh:
- Certificate dari Let's Encrypt
- Auto-renewal via certbot cronjob
- Renewal 30 hari sebelum expired
- Notification ke DevOps jika renewal gagal

---

## Routing & Load Balancing

### Load Balancer Configuration

{Jelaskan konfigurasi load balancer}

Contoh:
- **Algorithm**: Round Robin / Least Connections
- **Health Check**: GET /health setiap 10 detik
- **Session Persistence**: None (stateless)
- **SSL Offloading**: Yes (SSL termination di LB)

### Nginx Routing

{Jelaskan routing rules di Nginx}

| Domain/Path | Upstream | Purpose |
|-------------|----------|---------|
| {domain} | {app_2}:3000 | Frontend |
| {domain}/admin | {app_1}:9000 | CMS admin |
| {domain}/api | {app_1}:9000 | API endpoints |
| {domain}/statistik | {app_3}:3001 | Analytics |

---

## Network Security

### Security Measures

1. **Private Network**: Server tidak bisa diakses langsung dari internet
2. **Firewall**: UFW dengan default deny, whitelist specific IPs
3. **SSH Hardening**: Key-only authentication, no root login, fail2ban
4. **Docker Network Isolation**: Containers di isolated networks
5. **Port Binding**: Services bind ke 127.0.0.1 jika tidak perlu external access
6. **Network Monitoring**: Traffic monitoring, anomaly detection

### SSH Access Control

```bash
# /etc/ssh/sshd_config
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
AllowUsers {allowed_users}
MaxAuthTries 3
LoginGraceTime 30
```

### Fail2ban Configuration

```bash
sudo fail2ban-client status sshd
```

---

## Network Troubleshooting

### Common Issues

| Issue | Symptoms | Solution |
|-------|----------|----------|
| Cannot connect to DB | Connection timeout | Check firewall, security group, DB server status |
| Nginx 502 Bad Gateway | Upstream not responding | Check container status, logs, resource usage |
| SSL certificate error | Browser warning | Check certificate validity, renewal status |
| High latency | Slow response time | Check network traffic, DNS resolution, LB health |

### Diagnostic Commands

```bash
# Check connectivity
ping {target_ip}
telnet {target_ip} {port}
curl -v https://{domain}

# Check DNS
nslookup {domain}
dig {domain}

# Check routing
traceroute {target_ip}
ip route show

# Check firewall
sudo ufw status verbose
sudo iptables -L -n

# Check Docker networks
docker network ls
docker network inspect {network_name}
```

---

## Network Monitoring

### Tools

- **iftop**: Real-time bandwidth usage
- **nload**: Network traffic monitoring
- **tcpdump**: Packet capture
- **netstat**: Network connections

### Commands

```bash
# Real-time traffic
sudo iftop -i eth0

# Network statistics
sudo nload eth0

# Capture packets
sudo tcpdump -i eth0 port 80

# Active connections
sudo netstat -tulnp
sudo ss -tulnp
```

---

**Last Updated:** {YYYY-MM-DD}
**Maintained by:** DevOps Team
