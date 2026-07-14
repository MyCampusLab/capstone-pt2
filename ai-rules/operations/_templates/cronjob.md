# Cronjob Setup — {Job Name}

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** WAJIB jika menggunakan cronjob untuk scheduled tasks
> **Purpose:** Dokumentasi setup cronjob untuk {job name}
> **Output Location:** `{apps|backend|frontend}/docs/operations/cronjobs/` — **INSIDE git repo. DILARANG menulis credential aktual. Gunakan referensi .env atau prod-docs/.**

---

## Overview

**Job:** {Nama job, contoh: Daily Database Cleanup}  
**Schedule:** `{cron expression, contoh: 0 2 * * *}` (setiap hari jam 2 pagi)  
**Command:** `{command yang dijalankan}`  
**User:** `{user yang menjalankan, contoh: www-data}`

---

## Prerequisites

- Cron daemon sudah running di server
- User `{user}` sudah ada dan punya akses ke project
- Command/script sudah ditest dan berjalan dengan benar

**Check cron status:**
```bash
# Ubuntu/Debian
sudo systemctl status cron

# CentOS/RHEL
sudo systemctl status crond
```

---

## Cronjob Entry

**Edit crontab:**
```bash
# Edit crontab untuk user saat ini
crontab -e

# Edit crontab untuk user tertentu (butuh sudo)
sudo crontab -u {user} -e
```

**Add entry:**
```bash
{cron_expression} cd {project_path} && {command} >> {log_file} 2>&1
```

**Contoh:**
```bash
# Daily cleanup at 2 AM
0 2 * * * cd /var/www/myapp && php artisan cleanup:old-records >> /var/www/myapp/storage/logs/cleanup.log 2>&1

# Weekly report every Monday at 6 AM
0 6 * * 1 cd /var/www/myapp && php artisan report:generate-weekly >> /var/www/myapp/storage/logs/report.log 2>&1

# Every 5 minutes
*/5 * * * * cd /var/www/myapp && php artisan check:health >> /dev/null 2>&1
```

---

## Cron Expression Reference

```
* * * * *
│ │ │ │ │
│ │ │ │ └── Day of week (0-7, Sunday=0 or 7)
│ │ │ └──── Month (1-12)
│ │ └────── Day of month (1-31)
│ └──────── Hour (0-23)
└────────── Minute (0-59)
```

**Common patterns:**
- `* * * * *` — Every minute
- `*/5 * * * *` — Every 5 minutes
- `0 * * * *` — Every hour (at minute 0)
- `0 2 * * *` — Daily at 2 AM
- `0 0 * * 0` — Weekly on Sunday at midnight
- `0 0 1 * *` — Monthly on 1st at midnight
- `0 0 1 1 *` — Yearly on Jan 1st at midnight

---

## Setup Steps

### 1. Test command manually

```bash
cd {project_path}
{command}
```

**Expected:** Command runs successfully without error

### 2. Edit crontab

```bash
crontab -e
```

### 3. Add cronjob entry

```bash
{cron_expression} cd {project_path} && {command} >> {log_file} 2>&1
```

### 4. Save and exit

```bash
# In nano: Ctrl+O, Enter, Ctrl+X
# In vim: :wq
```

---

## Verification

**List all cronjobs:**
```bash
crontab -l
```

**Expected output:**
```
{cron_expression} cd {project_path} && {command} >> {log_file} 2>&1
```

**Check cron logs:**
```bash
# Ubuntu/Debian
grep CRON /var/log/syslog

# CentOS/RHEL
grep CRON /var/log/cron
```

**Check job output:**
```bash
tail -f {log_file}
```

---

## Troubleshooting

### Cronjob tidak jalan

**Symptom:** Job tidak dijalankan sesuai schedule

**Solutions:**
1. Check cron daemon is running:
   ```bash
   sudo systemctl status cron
   ```

2. Check crontab syntax:
   ```bash
   crontab -l
   ```

3. Check cron logs:
   ```bash
   grep CRON /var/log/syslog
   ```

4. Test command manually:
   ```bash
   cd {project_path} && {command}
   ```

### Command not found

**Symptom:** Log shows "command not found"

**Solution:** Use full path to command
```bash
# Wrong
0 2 * * * cd /var/www/myapp && php artisan cleanup

# Correct
0 2 * * * cd /var/www/myapp && /usr/bin/php artisan cleanup
```

**Find full path:**
```bash
which php
which node
which go
```

### Permission denied

**Symptom:** Log shows "Permission denied"

**Solution:** Check file permissions
```bash
# Check ownership
ls -la {project_path}

# Fix permissions
sudo chown -R {user}:{user} {project_path}
sudo chmod -R 755 {project_path}
```

### Environment variables not loaded

**Symptom:** Command works manually but not in cron

**Solution:** Source environment in cronjob
```bash
0 2 * * * . $HOME/.profile; cd {project_path} && {command}
```

Or use full environment:
```bash
0 2 * * * cd {project_path} && PATH=/usr/local/bin:/usr/bin:/bin {command}
```

---

## Maintenance

### Update cronjob

```bash
crontab -e
# Edit entry
# Save and exit
```

### Remove cronjob

```bash
crontab -e
# Delete entry (dd in vim, Ctrl+K in nano)
# Save and exit
```

### Backup crontab

```bash
crontab -l > crontab-backup-$(date +%Y%m%d).txt
```

### Restore crontab

```bash
crontab crontab-backup-20260609.txt
```

---

## Auto-Setup Script

**Script:** `{project_path}/docs/operations/scripts/setup-cronjob-{job}.sh`

```bash
#!/bin/bash
# Setup cronjob for {job}

PROJECT_PATH="{project_path}"
CRON_EXPRESSION="{cron_expression}"
COMMAND="{command}"
LOG_FILE="{log_file}"

# Backup current crontab
crontab -l > /tmp/crontab-backup-$(date +%Y%m%d_%H%M%S).txt

# Add new cronjob
(crontab -l 2>/dev/null; echo "$CRON_EXPRESSION cd $PROJECT_PATH && $COMMAND >> $LOG_FILE 2>&1") | crontab -

# Show updated crontab
echo "Updated crontab:"
crontab -l

echo "Cronjob setup completed for {job}"
```

**Run (auto-setup mode):**
```bash
bash {project_path}/docs/operations/scripts/setup-cronjob-{job}.sh
```

**Run (manual-setup mode):**
```bash
# Copy commands dari script dan jalankan manual
```
