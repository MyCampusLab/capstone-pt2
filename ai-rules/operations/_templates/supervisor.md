# Supervisor Configuration — {Service Name}

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** WAJIB jika menggunakan supervisor untuk background process
> **Purpose:** Dokumentasi setup supervisor untuk {service name}
> **Output Location:** `{apps|backend|frontend}/docs/operations/supervisor/` — **INSIDE git repo. DILARANG menulis credential aktual. Gunakan referensi .env atau prod-docs/.**

---

## Overview

**Service:** {Nama service, contoh: Queue Worker}  
**Command:** `{command yang dijalankan}`  
**User:** `{user yang menjalankan, contoh: www-data}`  
**Numprocs:** `{jumlah process, contoh: 2}`

---

## Prerequisites

- Supervisor sudah terinstall di server
- User `{user}` sudah ada dan punya akses ke project
- PHP/Node.js/Go sudah terinstall sesuai requirement

**Install supervisor (jika belum):**
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install supervisor

# CentOS/RHEL
sudo yum install supervisor
```

---

## Configuration File

**File:** `/etc/supervisor/conf.d/{project}-{service}.conf`

```ini
[program:{project}-{service}]
process_name=%(program_name)s_%(process_num)02d
command={full_command}
autostart=true
autorestart=true
user={user}
numprocs={numprocs}
redirect_stderr=true
stdout_logfile={project_path}/storage/logs/{service}.log
stopwaitsecs=3600
```

**Penjelasan:**
- `process_name` — nama process (otomatis numbering jika numprocs > 1)
- `command` — command yang dijalankan
- `autostart` — auto start saat server boot
- `autorestart` — auto restart jika crash
- `user` — user yang menjalankan process
- `numprocs` — jumlah process yang dijalankan (untuk load balancing)
- `redirect_stderr` — redirect stderr ke stdout
- `stdout_logfile` — lokasi log file
- `stopwaitsecs` — waktu tunggu sebelum force kill (penting untuk graceful shutdown)

---

## Setup Steps

### 1. Copy config file

```bash
sudo cp {project_path}/docs/operations/supervisor/{service}.conf /etc/supervisor/conf.d/
```

### 2. Reload supervisor

```bash
sudo supervisorctl reread
sudo supervisorctl update
```

### 3. Start service

```bash
sudo supervisorctl start {project}-{service}:*
```

---

## Verification

**Check status:**
```bash
sudo supervisorctl status {project}-{service}:*
```

**Expected output:**
```
{project}-{service}:{project}-{service}_00   RUNNING   pid 12345, uptime 0:05:23
{project}-{service}:{project}-{service}_01   RUNNING   pid 12346, uptime 0:05:23
```

**Check logs:**
```bash
tail -f {project_path}/storage/logs/{service}.log
```

---

## Common Commands

```bash
# Start all processes
sudo supervisorctl start {project}-{service}:*

# Stop all processes
sudo supervisorctl stop {project}-{service}:*

# Restart all processes
sudo supervisorctl restart {project}-{service}:*

# Check status
sudo supervisorctl status {project}-{service}:*

# Tail logs
sudo supervisorctl tail -f {project}-{service}:{project}-{service}_00
```

---

## Troubleshooting

### Process tidak start

**Symptom:** Status FATAL atau BACKOFF

**Solution:**
```bash
# Check log
sudo supervisorctl tail {project}-{service}:{project}-{service}_00 stderr

# Common issues:
# - Permission denied: check user and file permissions
# - Command not found: check full path to command
# - Module not found: check if dependencies installed
```

### Process sering restart

**Symptom:** Status RUNNING tapi uptime reset terus

**Solution:**
- Check application logs untuk error
- Increase `stopwaitsecs` jika graceful shutdown butuh waktu lama
- Check memory limit (OOM killer)

### Log file tidak ditulis

**Symptom:** Log file kosong atau tidak ada

**Solution:**
```bash
# Check log directory exists and writable
ls -la {project_path}/storage/logs/

# Create if not exists
mkdir -p {project_path}/storage/logs/
chown {user}:{user} {project_path}/storage/logs/
```

---

## Maintenance

### Update configuration

```bash
# Edit config file
sudo nano /etc/supervisor/conf.d/{project}-{service}.conf

# Reload and restart
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl restart {project}-{service}:*
```

### Remove service

```bash
sudo supervisorctl stop {project}-{service}:*
sudo rm /etc/supervisor/conf.d/{project}-{service}.conf
sudo supervisorctl reread
sudo supervisorctl update
```

---

## Auto-Setup Script

**Script:** `{project_path}/docs/operations/scripts/setup-supervisor-{service}.sh`

```bash
#!/bin/bash
# Setup supervisor for {service}

PROJECT_PATH="{project_path}"
SERVICE_NAME="{service}"
USER="{user}"

# Copy config
sudo cp $PROJECT_PATH/docs/operations/supervisor/$SERVICE_NAME.conf /etc/supervisor/conf.d/

# Create log directory
mkdir -p $PROJECT_PATH/storage/logs/
chown $USER:$USER $PROJECT_PATH/storage/logs/

# Reload supervisor
sudo supervisorctl reread
sudo supervisorctl update

# Start service
sudo supervisorctl start {project}-$SERVICE_NAME:*

# Show status
sudo supervisorctl status {project}-$SERVICE_NAME:*

echo "Supervisor setup completed for $SERVICE_NAME"
```

**Run (auto-setup mode):**
```bash
bash {project_path}/docs/operations/scripts/setup-supervisor-{service}.sh
```

**Run (manual-setup mode):**
```bash
# Copy commands dari script dan jalankan manual
```
