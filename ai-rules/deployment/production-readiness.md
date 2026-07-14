# Production Readiness Guide — {Nama Project}

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** BRIDGE DOCUMENT — Menghubungkan informasi dari `dev-docs/` ke `prod-docs/`
> **Purpose:** Checklist dan requirements lengkap untuk deployment ke production server

---

## Overview

Dokumen ini adalah **jembatan** antara dokumentasi development (`dev-docs/`) dan dokumentasi server production (`prod-docs/`). Gunakan dokumen ini untuk:

1. **AI agent yang sama** yang development dan deploy — sudah punya konteks, tinggal setup server
2. **DevOps/SysAdmin lain** yang deploy — butuh informasi lengkap dari development
3. **Handover** dari development ke operations team

---

## 1. Project Information

**Sumber:** `dev-docs/ai/PROJECT_CONTEXT.md`

| Item | Value |
|------|-------|
| Project Name | {nama_project} |
| Project Type | {Monolith / Fullstack} |
| Backend Framework | {Laravel / Express / Go Fiber / ...} |
| Frontend Framework | {Nuxt / Next.js / React / ...} |
| Database | {PostgreSQL / MySQL / ...} |
| Cache | {Redis / Memcached / ...} |
| Queue | {Redis Streams / RabbitMQ / ...} |

---

## 2. System Requirements

### 2.1 Server Specifications

**Minimum requirements:**

| Resource | Minimum | Recommended |
|----------|---------|-------------|
| CPU | {2 cores} | {4 cores} |
| RAM | {4 GB} | {8 GB} |
| Disk | {50 GB} | {100 GB} |
| OS | {Ubuntu 22.04 LTS} | {Ubuntu 22.04 LTS} |
| Network | {1 Gbps} | {1 Gbps} |

### 2.2 Software Requirements

**Sumber:** `dev-docs/ai/PROJECT_CONTEXT.md` (Runtime Stack)

| Software | Version | Purpose |
|----------|---------|---------|
| Docker | {24.x} | Container runtime |
| Docker Compose | {2.x} | Container orchestration |
| Nginx | {1.24} | Reverse proxy |
| PHP | {8.2} | Backend runtime (if Laravel) |
| Node.js | {20.x} | Frontend runtime (if Nuxt) |
| PostgreSQL | {15} | Database |
| Redis | {7.x} | Cache & queue |

### 2.3 Network Requirements

**Sumber:** `dev-docs/architecture/api-flow.md`

| Port | Service | Protocol | Notes |
|------|---------|----------|-------|
| 80 | HTTP | TCP | Redirect to HTTPS |
| 443 | HTTPS | TCP | Main application |
| 22 | SSH | TCP | Server access (restrict IP) |

**Firewall rules:**
- Allow inbound: 80, 443, 22 (restricted IPs only)
- Allow outbound: all (for package updates, external APIs)

---

## 3. Application Architecture

**Sumber:** `dev-docs/architecture/`

### 3.1 Component Overview

```
{Copy diagram dari dev-docs/architecture/api-flow.md}
```

### 3.2 Container Structure

**Sumber:** `dev-docs/architecture/backend-structure.md`, `dev-docs/architecture/frontend-structure.md`

| Container | Image | Port | Network | Volume |
|-----------|-------|------|---------|--------|
| {backend} | {php:8.2-fpm} | {9000} | {app-net} | {./backend:/var/www} |
| {frontend} | {node:20} | {3000} | {app-net} | {./frontend:/app} |
| {nginx} | {nginx:1.24} | {80,443} | {app-net} | {./nginx:/etc/nginx} |
| {postgres} | {postgres:15} | {5432} | {db-net} | {postgres-data} |
| {redis} | {redis:7} | {6379} | {app-net} | {redis-data} |

### 3.3 Database Schema

**Sumber:** `dev-docs/architecture/database.md`

| Table | Purpose | Size Estimate |
|-------|---------|---------------|
| {users} | User accounts | {1000 rows} |
| {sessions} | Active sessions | {5000 rows} |
| {logs} | Activity logs | {100K rows/month} |

---

## 4. Environment Variables

**Sumber:** `.env.example` dari repository

### 4.1 Backend Environment

```bash
# Copy dari .env.example backend
APP_NAME={project_name}
APP_ENV=production
APP_DEBUG=false
APP_URL=https://{domain}

DB_CONNECTION=pgsql
DB_HOST={db_host}
DB_PORT=5432
DB_DATABASE={db_name}
DB_USERNAME={db_user}
DB_PASSWORD={generate_strong_password}

REDIS_HOST={redis_host}
REDIS_PORT=6379
REDIS_PASSWORD={generate_strong_password}

# API Keys (jika ada)
THIRD_PARTY_API_KEY={get_from_provider}
```

### 4.2 Frontend Environment

```bash
# Copy dari .env.example frontend
NUXT_PUBLIC_API_BASE=https://{domain}/api
NUXT_PUBLIC_APP_NAME={project_name}

# Server-side only
DATABASE_URL=postgresql://{user}:{password}@{host}:{port}/{db}
```

### 4.3 Security Notes

**Sumber:** `dev-docs/security/README.md`

- [ ] Semua password di-generate dengan strong password generator (min 32 chars)
- [ ] Tidak ada credential yang di-hardcode di code
- [ ] Semua API keys di-store di environment variables
- [ ] `.env` file di-set permission 600 (read-only owner)

---

## 5. Deployment Process

**Sumber:** `dev-docs/deployment/README.md`

### 5.1 Initial Setup

```bash
# 1. Clone repository
git clone {repo_url} /opt/{project_name}
cd /opt/{project_name}

# 2. Setup environment
cp .env.example .env
nano .env  # Edit dengan production values

# 3. Build containers
docker compose build

# 4. Start services
docker compose up -d

# 5. Run migrations
docker compose exec backend php artisan migrate --force

# 6. Seed database (jika perlu)
docker compose exec backend php artisan db:seed --force

# 7. Verify deployment
curl -I https://{domain}
```

### 5.2 Update Process

```bash
# 1. Pull latest code
cd /opt/{project_name}
git pull origin main

# 2. Rebuild containers (jika ada perubahan dependency)
docker compose build

# 3. Restart services
docker compose up -d

# 4. Run migrations (jika ada)
docker compose exec backend php artisan migrate --force

# 5. Clear cache
docker compose exec backend php artisan config:clear
docker compose exec backend php artisan cache:clear

# 6. Verify
curl -I https://{domain}
```

### 5.3 Rollback Process

```bash
# Jika deployment gagal:
# 1. Revert code
git reset --hard HEAD~1

# 2. Rebuild
docker compose build

# 3. Restart
docker compose up -d

# 4. Rollback migration (jika perlu)
docker compose exec backend php artisan migrate:rollback --step=1
```

---

## 6. Operations Setup

**Sumber:** `dev-docs/operations/`

### 6.1 Supervisor (Queue Worker)

**Sumber:** `dev-docs/operations/README.md` (Supervisor section)

```ini
# /etc/supervisor/conf.d/{project}-queue.conf
[program:{project}-queue]
process_name=%(program_name)s_%(process_num)02d
command=docker compose -f /opt/{project_name}/docker-compose.yml exec -T backend php artisan queue:work redis --sleep=3 --tries=3
autostart=true
autorestart=true
user=www-data
numprocs=2
redirect_stderr=true
stdout_logfile=/var/log/{project}/queue.log
```

**Setup:**
```bash
sudo cp /opt/{project_name}/docs/supervisor/queue.conf /etc/supervisor/conf.d/
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl start {project}-queue:*
```

### 6.2 Cronjobs

**Sumber:** `dev-docs/operations/README.md` (Cronjob section)

```bash
# Edit crontab
crontab -e

# Tambahkan:
# Daily cleanup (hapus logs lama)
0 2 * * * docker compose -f /opt/{project_name}/docker-compose.yml exec -T backend php artisan logs:cleanup --days=30

# Weekly report generation
0 6 * * 1 docker compose -f /opt/{project_name}/docker-compose.yml exec -T backend php artisan reports:generate-weekly

# Database backup (lihat section backup)
0 3 * * * /opt/{project_name}/scripts/backup-database.sh
```

### 6.3 Backup Strategy

**Sumber:** `dev-docs/operations/README.md` (Backup section)

**Backup script:**
```bash
#!/bin/bash
# /opt/{project_name}/scripts/backup-database.sh

BACKUP_DIR=/backup/{project_name}
DATE=$(date +%Y%m%d_%H%M%S)
DB_CONTAINER={project_name}-postgres-1

mkdir -p $BACKUP_DIR

# Backup database
docker exec $DB_CONTAINER pg_dump -U {db_user} {db_name} | gzip > $BACKUP_DIR/db_$DATE.sql.gz

# Backup uploads (jika ada)
tar -czf $BACKUP_DIR/uploads_$DATE.tar.gz /opt/{project_name}/backend/storage/app/public

# Keep only last 30 days
find $BACKUP_DIR -name "*.gz" -type f -mtime +30 -delete

echo "Backup completed: $DATE"
```

**Setup:**
```bash
chmod +x /opt/{project_name}/scripts/backup-database.sh
# Tambahkan ke crontab (lihat section 6.2)
```

### 6.4 SSL Certificate

**Sumber:** `dev-docs/deployment/README.md`

```bash
# Install certbot
sudo apt install certbot python3-certbot-nginx

# Get certificate
sudo certbot --nginx -d {domain} -d www.{domain}

# Auto-renewal (sudah otomatis via systemd timer)
sudo systemctl status certbot.timer
```

---

## 7. Security Hardening

**Sumber:** `dev-docs/security/README.md`

### 7.1 Server Security

- [ ] Disable root login via SSH
- [ ] Use SSH key authentication only
- [ ] Install fail2ban
- [ ] Configure UFW firewall
- [ ] Enable automatic security updates

### 7.2 Application Security

**Sumber:** `dev-docs/security/README.md` (Part B: HTTP Security Headers)

- [ ] Enable security headers (CSP, HSTS, X-Frame-Options)
- [ ] Configure CORS (jika ada API)
- [ ] Enable rate limiting
- [ ] Setup CSRF protection
- [ ] Enable input validation

### 7.3 Database Security

- [ ] Use strong password (min 32 chars)
- [ ] Restrict database access to application network only
- [ ] Enable SSL connection (jika remote database)
- [ ] Regular backup (daily)
- [ ] Test restore procedure monthly

---

## 8. Monitoring & Alerting

**Sumber:** `dev-docs/operations/README.md` (Monitoring section)

### 8.1 Health Checks

```bash
# Application health
curl -f https://{domain}/health

# Database connection
docker compose exec backend php artisan db:check

# Queue status
docker compose exec backend php artisan queue:status
```

### 8.2 Log Monitoring

```bash
# Application logs
docker compose logs -f backend
docker compose logs -f frontend

# Nginx access logs
docker compose logs -f nginx

# System logs
journalctl -u docker -f
```

### 8.3 Alerting Setup

**Jika menggunakan external monitoring (UptimeRobot, Datadog, dll):**

- [ ] Setup uptime monitoring (check every 1 minute)
- [ ] Setup SSL certificate expiry alert (30 days before)
- [ ] Setup disk space alert (> 80% usage)
- [ ] Setup error rate alert (> 5% 5xx responses)

---

## 9. Pre-Launch Checklist

### 9.1 Infrastructure

- [ ] Server provisioned dengan specs yang sesuai
- [ ] Domain DNS configured (A record ke server IP)
- [ ] SSL certificate installed dan auto-renewal enabled
- [ ] Firewall configured (UFW aktif)
- [ ] SSH hardened (key-only, no root login)
- [ ] Fail2ban installed dan configured

### 9.2 Application

- [ ] Environment variables configured (semua dari `.env.example`)
- [ ] Database migrated dan seeded (jika perlu)
- [ ] Storage permissions correct (`chmod -R 775 storage/`)
- [ ] Queue worker running (supervisor)
- [ ] Cronjobs configured dan tested
- [ ] Backup script configured dan tested

### 9.3 Security

- [ ] Security headers enabled
- [ ] CORS configured (jika ada API)
- [ ] Rate limiting enabled
- [ ] Input validation active
- [ ] No debug mode (`APP_DEBUG=false`)
- [ ] No sensitive data in logs

### 9.4 Performance

- [ ] Database indexes created
- [ ] Cache configured (Redis)
- [ ] Static assets optimized (compression, caching)
- [ ] CDN configured (jika perlu)
- [ ] Load testing completed

### 9.5 Monitoring

- [ ] Health check endpoint accessible
- [ ] Log monitoring configured
- [ ] Alerting configured (uptime, SSL, disk, errors)
- [ ] Backup monitoring configured

### 9.6 Documentation

- [ ] `prod-docs/` filled dengan informasi aktual server
- [ ] Deployment process documented dan tested
- [ ] Rollback process documented dan tested
- [ ] Emergency contacts documented
- [ ] Runbook untuk common issues

---

## 10. Handover to Operations

**Jika AI agent yang development berbeda dengan yang maintain server:**

### 10.1 Information to Provide

1. **Repository access:**
   - Git repository URL → lihat [git-remote.md](./git-remote.md) untuk auto-detection dan credential
   - Branch strategy (main = production, dev = staging)
   - Deployment credentials (SSH deploy key atau HTTPS token)
   - **Server git setup:** [prod-docs/docs/operations/repository-access.md](../../prod-docs/docs/operations/repository-access.md)

2. **Server access:**
   - SSH credentials (key-based)
   - Sudo access (jika perlu)
   - Database credentials

3. **Documentation:**
   - `prod-docs/` folder (sudah filled)
   - `dev-docs/` folder (untuk reference)
   - This file (`production-readiness.md`)

4. **Monitoring access:**
   - Uptime monitoring dashboard
   - Log monitoring dashboard
   - Alerting channels (Slack, email, PagerDuty)

### 10.2 Knowledge Transfer

**Topik yang harus di-explain:**

1. **Architecture overview** — bagaimana aplikasi bekerja
2. **Deployment process** — cara deploy update
3. **Rollback process** — cara rollback jika ada issue
4. **Backup & restore** — cara backup dan restore database
5. **Common issues** — masalah yang sering terjadi dan solusinya
6. **Escalation path** — siapa yang dihubungi jika ada issue critical

### 10.3 Emergency Contacts

| Role | Name | Contact | When to Contact |
|------|------|---------|-----------------|
| Developer | {name} | {email/phone} | Application bugs, code issues |
| DevOps | {name} | {email/phone} | Server issues, deployment problems |
| Security | {name} | {email/phone} | Security incidents |
| Management | {name} | {email/phone} | Critical issues, downtime |

---

## 11. Post-Launch Tasks

### 11.1 Day 1

- [ ] Monitor error logs closely
- [ ] Check performance metrics
- [ ] Verify all health checks passing
- [ ] Test user flows manually

### 11.2 Week 1

- [ ] Review logs daily
- [ ] Check backup success daily
- [ ] Monitor resource usage trends
- [ ] Address any user-reported issues

### 11.3 Month 1

- [ ] Review performance metrics
- [ ] Optimize slow queries (jika ada)
- [ ] Review and update documentation
- [ ] Plan for scaling (jika perlu)

---

## References

**Development documentation:**
- `dev-docs/ai/PROJECT_CONTEXT.md` — Project overview dan tech stack
- `dev-docs/architecture/` — Application architecture
- `dev-docs/deployment/` — Deployment process
- `dev-docs/operations/` — Operations setup (supervisor, cronjob, backup)
- `dev-docs/security/README.md` — Security requirements

**Production documentation:**
- `prod-docs/AGENTS.md` — AI agent contract untuk server
- `prod-docs/docs/` — Technical documentation server
- `prod-docs/reports-agents/` — Audit log tasks di server

---

**Last Updated:** {YYYY-MM-DD}
**Prepared by:** AI Agent (Development)
**Approved by:** {name}
