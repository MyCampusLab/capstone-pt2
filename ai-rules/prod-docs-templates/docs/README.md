# Dokumentasi Teknis — {Server Name}

> **IMMUTABLE — AI TIDAK BOLEH mengubah file ini. Ini adalah TEMPLATE. AI membuat output di prod-docs/docs/ dari template ini.**

> **Server:** {hostname} ({ip_address})
> **Domain:** {domain}
> **Terakhir diperbarui:** {YYYY-MM-DD}

Dokumentasi ini dibuat agar AI agent dan tim teknis dapat memahami arsitektur, tech stack, dan operasional server dengan cepat.

---

## Struktur Dokumentasi

```
docs/
├── README.md                          # ← File ini (index)
├── architecture/
│   ├── overview.md                    # Arsitektur umum server
│   └── network-topology.md            # Topologi jaringan & routing
├── tech-stack/
│   ├── {app-1}.md                     # Dokumentasi aplikasi 1
│   ├── {app-2}.md                     # Dokumentasi aplikasi 2
│   ├── nginx.md                       # Web server & reverse proxy
│   ├── docker.md                      # Container runtime
│   ├── database.md                    # Database servers
│   ├── redis.md                       # Cache & session (jika ada)
│   └── {lainnya}.md                   # Komponen lain
├── operations/
│   ├── deployment.md                  # Workflow deploy & auto-deploy
│   ├── backup.md                      # Prosedur backup
│   ├── monitoring.md                  # Logging & monitoring
│   └── security.md                    # Security hardening
├── changelog.md                       # Log perubahan teknologi & aturan
└── troubleshooting.md                 # Masalah umum & solusi
```

---

## Quick Reference

### Server Overview

| Item | Value |
|------|-------|
| Hostname | {hostname} |
| IP Address | {ip_address} |
| OS | {os_version} |
| CPU | {cpu_cores} cores |
| RAM | {ram_gb} GB |
| Disk | {disk_size} |
| Domain | {domain} |

### Applications

| App | Tech | Port | Container | Compose File |
|-----|------|------|-----------|--------------|
| {app-1} | {tech_stack} | {port} | {container_name} | {compose_path} |
| {app-2} | {tech_stack} | {port} | {container_name} | {compose_path} |
| nginx | Nginx {version} | 80/443 | {container_or_system} | {config_path} |

### Databases

| Type | Host | Port | Purpose |
|------|------|------|---------|
| {db_type} | {host} | {port} | {purpose} |

---

## Referensi Dokumentasi Lain

| Lokasi | Isi |
|--------|-----|
| `~/reports-agents/YYYY-MM-DD/` | Laporan per-task oleh AI agent (format deskriptif + evidence) |
| `~/reports-agents/changelog.md` | Audit log per-task (apa yang dikerjakan, oleh siapa, status) |
| `~/docs/changelog.md` | Log perubahan teknologi & arsitektur (apa yang berubah di sistem) |
| `~/AGENTS.md` | Aturan utama untuk AI agent (entry point otomatis) |
| `/opt/docs/` | Panduan operasional (deploy, backup, runbook) |

---

##  Sumber Informasi dari Development (dev-docs/)

**Dokumentasi di folder ini diisi berdasarkan informasi dari development team.**

### Initial Setup: Bridge Document

Saat pertama kali setup server, gunakan **`production-readiness.md`** dari development team:

**Lokasi:** `ai-rules/deployment/production-readiness.md` (immutable template)

**Isi bridge document:**
- Tech stack versions yang harus diinstall
- Architecture diagram dan komponen
- Database schema dan requirements
- Deployment process step-by-step
- Operations setup (supervisor, cronjob, backup)
- Security requirements dan hardening
- Environment variables yang diperlukan

### Cara Mengisi Dokumentasi dari Bridge Document

| File di `~/docs/` | Sumber dari `production-readiness.md` |
|-------------------|--------------------------------------|
| `architecture/overview.md` | Section "Architecture Diagram" + "Component Overview" |
| `architecture/network-topology.md` | Section "Network Requirements" + "Firewall rules" |
| `tech-stack/{app}.md` | Section "Tech Stack" + "Software Requirements" |
| `tech-stack/database.md` | Section "Database Schema" + "Database Requirements" |
| `operations/deployment.md` | Section "Deployment Process" |
| `operations/backup.md` | Section "Backup Strategy" |
| `operations/security.md` | Section "Security Hardening" |
| `operations/monitoring.md` | Section "Monitoring & Alerting" |

### Workflow Pengisian Dokumentasi

```
┌─────────────────────────────────────────────────────────────┐
│  1. Terima production-readiness.md dari development team    │
│     (atau baca dari dev-docs/ jika AI yang sama)            │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  2. Setup server sesuai checklist di production-readiness   │
│     - Install software requirements                         │
│     - Configure network & firewall                          │
│     - Setup SSL certificate                                 │
│     - Deploy application                                    │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  3. Fill ~/docs/ dengan informasi aktual server             │
│     - Copy informasi dari production-readiness.md           │
│     - Sesuaikan dengan kondisi aktual (IP, port, dll)       │
│     - Tambahkan detail spesifik server                      │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  4. Verify semua checklist di production-readiness.md       │
│     - Pastikan semua requirements terpenuhi                 │
│     - Test deployment process                               │
│     - Test backup & restore                                 │
└─────────────────────────────────────────────────────────────┘
```

### Contoh: Mengisi tech-stack/nginx.md

**Dari production-readiness.md:**
```markdown
## Software Requirements
| Software | Version | Purpose |
|----------|---------|---------|
| Nginx | 1.24 | Reverse proxy |
```

**Ke ~/docs/tech-stack/nginx.md:**
```markdown
# Nginx — Web Server & Reverse Proxy

> **Version:** 1.24.0
> **Last Updated:** 2026-06-09

## Overview
Nginx digunakan sebagai reverse proxy untuk:
- {app-1} (port 3000)
- {app-2} (port 3001)

## Configuration
**File:** `/etc/nginx/sites-available/{domain}`

[Detail konfigurasi aktual server...]

## Useful Commands
[Commands untuk manage Nginx...]
```

### Jika Tidak Ada Bridge Document

Jika development team tidak menyediakan `production-readiness.md`:

1. **Minta informasi berikut:**
   - Tech stack versions (PHP, Node.js, database, dll)
   - Architecture diagram
   - Database schema
   - Deployment process
   - Environment variables (`.env.example`)

2. **Atau akses dev-docs/ langsung** (jika punya akses):
   ```bash
   # Di project repository
   cat dev-docs/ai/PROJECT_CONTEXT.md        # Tech stack
   cat dev-docs/architecture/overview.md     # Architecture
   cat dev-docs/architecture/database.md     # Database
   cat ai-rules/deployment/README.md         # Deployment
   cat ai-rules/operations/README.md         # Operations
   ```

3. **Dokumentasikan asumsi** jika informasi tidak lengkap:
   ```markdown
   ## Assumptions (perlu konfirmasi)
   - Nginx version: 1.24 (assumed, perlu konfirmasi)
   - Database: PostgreSQL 15 (assumed, perlu konfirmasi)
   ```

---

## Cara Pakai untuk AI Agent

1. **Sesi baru**: Baca `~/AGENTS.md` (entry point) → `~/docs/README.md` (index) → `~/reports-agents/changelog.md` (audit log)
2. **Sebelum task**: Baca file terkait di `~/docs/tech-stack/` untuk memahami komponen yang akan diubah
3. **Saat task**: Ikuti format laporan di `~/AGENTS.md` — deskriptif, teknis, dengan evidence
4. **Setelah task**: 
   - Tulis laporan di `~/reports-agents/YYYY-MM-DD/<task-name>.md`
   - Update `~/reports-agents/changelog.md` (tambah entry audit log)
   - Update `~/docs/changelog.md` jika ada perubahan teknologi/arsitektur
   - Update **SEMUA** file `~/docs/` yang terdampak (lihat checklist di `~/AGENTS.md`)
5. **Report harian**: Jika ada task hari itu, buat `~/reports-agents/YYYY-MM-DD/00-summary.md`

---

## Common Commands

### Check System Status

```bash
# Disk, memory, CPU
df -h
free -h
htop

# Docker
docker ps
docker stats
docker logs <container>

# Services
systemctl status nginx
systemctl list-units --type=service

# Network
ss -tlnp
curl -I https://domain
```

### Application Management

```bash
# Restart container
cd /opt/<app> && docker compose restart

# View logs
docker logs -f <container>
tail -f /var/log/nginx/access.log

# Rebuild and restart
cd /opt/<app> && docker compose up -d --build

# Enter container
docker exec -it <container> sh
```

### Backup & Restore

```bash
# Database backup
mysqldump -u user -p database > backup.sql

# Docker volume backup
docker run --rm -v volume:/data -v $(pwd):/backup alpine tar czf /backup/volume.tar.gz /data

# Restore
mysql -u user -p database < backup.sql
```

---

## Emergency Contacts

| Role | Contact | When to Call |
|------|---------|--------------|
| DevOps Lead | {contact} | Infrastructure issues, security incidents |
| Backend Lead | {contact} | Application bugs, database issues |
| System Admin | {contact} | OS-level issues, network problems |

---

**Last Updated:** {YYYY-MM-DD}
**Maintained by:** AI Agent + DevOps Team
