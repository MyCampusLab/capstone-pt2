# Operations Documentation — Server Setup & Maintenance

> **Status:** WAJIB untuk semua project yang memiliki fitur requiring server setup (queue, scheduler, cronjob, backup, dll)
> **Purpose:** Dokumentasi teknis operasional yang harus di-setup di server production agar aplikasi berjalan dengan benar.

---

## IMMUTABLE -- AI TIDAK BOLEH MENGUBAH FILE INI. Baca template ini, lalu BUAT file BARU di folder output (dev-docs/, planning/, dll) -- JANGAN ubah template ini.

###  CRITICAL: Operations Documentation is Mandatory

Setiap kali AI membuat fitur yang **butuh setup di server**, AI **WAJIB** membuat dokumentasi operations yang lengkap.

**Fitur yang WAJIB punya dokumentasi operations:**
- Queue worker (Redis, RabbitMQ, SQS)
- Scheduler / Cronjob (daily cleanup, report generation, dll)
- Supervisor / Process manager
- Database backup script
- SSL certificate renewal
- Log rotation
- Third-party service integration (webhook, API callback)
- Health check endpoint
- Monitoring setup (Prometheus, Grafana)
- Cache warming / preloading
- File storage sync (S3, MinIO)
- Email queue / notification worker
- WebSocket server
- Real-time event processor

### Kapan Dokumentasi Dibuat?

**AI WAJIB membuat dokumentasi operations saat:**
1. Membuat fitur baru yang butuh background process
2. Menambahkan scheduler / cronjob
3. Setup queue worker
4. Integrasi dengan third-party service
5. Membuat script backup / maintenance
6. Konfigurasi server (supervisor, nginx, systemd)

### Dimana Dokumentasi Disimpan?

> **PERINGATAN LOKASI — BACA SEBELUM MEMBUAT DOKUMENTASI:**
> - Folder operations `{apps|backend|frontend}/docs/operations/` adalah **PENGECUALIAN KHUSUS** — HANYA untuk config server (supervisor, systemd, cronjob) yang harus ship bersama kode.
> - **SECURITY BOUNDARY:** File di `{apps}/docs/operations/` berada DI DALAM git repo dan WILL di-push ke GitHub. **DILARANG menulis credential aktual** (password, token, API key, SSH key, database username, connection string, server IP). Gunakan referensi ke `.env` atau `prod-docs/`.
> - File ini (`ai-rules/operations/README.md`) dan template di `_templates/` berada di **IMMUTABLE `ai-rules/`** — AI HANYA MEMBACA.
> - `dev-docs/`, `planning/`, `AGENTS.md` **TETAP di PROJECT ROOT sejajar dengan `apps/`** — JANGAN PERNAH dipindahkan ke dalam `apps/`.

**Struktur folder (DI DALAM folder kode — HANYA untuk operations output):**
```
{apps|backend|frontend}/
├── docs/
│   └── operations/
│       ├── README.md              ← Overview (isi AI)
│       ├── supervisor/            ← Config supervisor
│       ├── cronjobs/              ← Cronjob setup
│       ├── scripts/               ← Script operasional
│       ├── systemd/               ← Systemd service files
│       └── monitoring/            ← Monitoring setup
```

### Format Dokumentasi

Setiap dokumentasi operations **WAJIB** include:

1. **Apa** — nama service/fitur
2. **Kenapa** — kenapa butuh setup di server
3. **Prerequisites** — apa yang harus ada sebelum setup
4. **Step-by-step setup** — cara setup lengkap
5. **Verifikasi** — cara cek apakah setup berhasil
6. **Troubleshooting** — masalah umum dan solusinya
7. **Maintenance** — cara update / restart / stop

### Auto-Setup vs Manual-Setup

**Ada 2 mode:**

| Mode | Deskripsi | Kapan Pakai |
|------|-----------|-------------|
| **Auto-setup** | AI langsung jalankan setup di server (jika ada akses SSH) | Development / staging environment |
| **Manual-setup** | AI buat dokumentasi, user jalankan manual | Production environment (safer) |

**Default:** Manual-setup (AI buat docs, user yang jalankan)

**Cara specify:**
- Di `PROJECT_BRIEF.md` section "Deployment & Operations"
- Atau di `dev-docs/deployment/ssh-access.md` (field `AUTO_SETUP_OPERATIONS: true/false`)

---

## Quick Reference

### Supervisor Config

```ini
; Contoh: /etc/supervisor/conf.d/{project}-queue.conf
[program:{project}-queue]
process_name=%(program_name)s_%(process_num)02d
command=php /path/to/project/artisan queue:work redis --sleep=3 --tries=3
autostart=true
autorestart=true
user=www-data
numprocs=2
redirect_stderr=true
stdout_logfile=/path/to/project/storage/logs/queue.log
```

**Setup:**
```bash
sudo cp docs/operations/supervisor/queue.conf /etc/supervisor/conf.d/
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl start {project}-queue:*
```

**Verifikasi:**
```bash
sudo supervisorctl status {project}-queue:*
```

---

### Cronjob Setup

```bash
# Edit crontab
crontab -e

# Tambahkan:
* * * * * cd /path/to/project && php artisan schedule:run >> /dev/null 2>&1
0 2 * * * /path/to/project/docs/operations/scripts/backup-database.sh
```

**Verifikasi:**
```bash
crontab -l
```

---

### Systemd Service

```ini
# /etc/systemd/system/{project}-worker.service
[Unit]
Description={Project} Background Worker
After=network.target

[Service]
Type=simple
User=www-data
WorkingDirectory=/path/to/project
ExecStart=/usr/bin/php /path/to/project/artisan queue:work --daemon
Restart=always

[Install]
WantedBy=multi-user.target
```

**Setup:**
```bash
sudo cp docs/operations/systemd/worker.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable {project}-worker
sudo systemctl start {project}-worker
```

**Verifikasi:**
```bash
sudo systemctl status {project}-worker
```

---

### Database Backup Script

```bash
#!/bin/bash
# docs/operations/scripts/backup-database.sh

# Load environment variables — NEVER hardcode credentials in scripts inside git repo
source /path/to/project/.env

BACKUP_DIR="/path/to/backups"
DATE=$(date +%Y%m%d_%H%M%S)
DB_NAME="$DB_DATABASE"
DB_USER="$DB_USERNAME"
DB_PASS="$DB_PASSWORD"

mkdir -p $BACKUP_DIR

mysqldump -u$DB_USER -p$DB_PASS $DB_NAME | gzip > $BACKUP_DIR/$DB_NAME-$DATE.sql.gz

# Keep only last 30 days
find $BACKUP_DIR -name "*.sql.gz" -type f -mtime +30 -delete

echo "Backup completed: $DB_NAME-$DATE.sql.gz"
```

**Setup cronjob:**
```bash
0 2 * * * /path/to/project/docs/operations/scripts/backup-database.sh
```

---

## Checklist Operations

**Sebelum deploy ke production, pastikan:**

- [ ] Semua queue worker sudah didokumentasikan
- [ ] Semua cronjob sudah didokumentasikan
- [ ] Backup script sudah dibuat dan ditest
- [ ] Log rotation sudah dikonfigurasi
- [ ] SSL certificate auto-renewal sudah setup
- [ ] Health check endpoint sudah ada
- [ ] Monitoring sudah dikonfigurasi
- [ ] Alert sudah setup untuk critical errors

---

## Template Files

Lihat folder `_templates/` untuk template dokumentasi:
- `supervisor.md` — template dokumentasi supervisor
- `cronjob.md` — template dokumentasi cronjob
- `scheduler.md` — template dokumentasi scheduler
- `backup.md` — template dokumentasi backup
- `monitoring.md` — template dokumentasi monitoring
