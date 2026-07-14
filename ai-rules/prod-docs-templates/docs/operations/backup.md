# Backup & Recovery — {Server Name}

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Terakhir diperbarui:** {YYYY-MM-DD}

---

## Overview

{Jelaskan strategi backup yang digunakan di server ini}

Contoh:
Server ini menggunakan **automated daily backup** untuk database dan application storage. Backup disimpan di {local/remote/cloud} dengan retention policy {X days}. Backup di-encrypt dengan AES-256 untuk security.

---

## Backup Strategy

| Item | Value |
|------|-------|
| Frequency | {daily/hourly/real-time} |
| Retention | {X days/weeks/months} |
| Storage | {local/remote/S3/GCS} |
| Encryption | {AES-256/none} |
| Compression | {gzip/bzip2/none} |
| Verification | {checksum/test-restore/none} |

---

## What Gets Backed Up

| Component | Backup Method | Frequency | Retention |
|-----------|---------------|-----------|-----------|
| Database | {mysqldump/pg_dump} | {daily} | {30 days} |
| Application Code | {git/tar} | {daily} | {7 days} |
| User Uploads | {tar/rsync} | {daily} | {30 days} |
| Configuration | {tar} | {weekly} | {90 days} |
| Logs | {tar} | {weekly} | {30 days} |

---

## Backup Scripts

### Database Backup

```bash
#!/bin/bash
# /opt/docs/backup-database.sh

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR={backup_directory}
DB_NAME={database_name}
DB_USER={database_user}

# Create backup
mysqldump -u$DB_USER -p$DB_PASS $DB_NAME | gzip > $BACKUP_DIR/db-$DB_NAME-$DATE.sql.gz

# Verify backup
gunzip -t $BACKUP_DIR/db-$DB_NAME-$DATE.sql.gz

# Remove old backups (older than 30 days)
find $BACKUP_DIR -name "db-$DB_NAME-*.sql.gz" -mtime +30 -delete

echo "Backup completed: db-$DB_NAME-$DATE.sql.gz"
```

### Application Backup

```bash
#!/bin/bash
# /opt/docs/backup-apps.sh

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR={backup_directory}

# Backup application code
tar -czf $BACKUP_DIR/app-{app_name}-$DATE.tar.gz /opt/{app_name}

# Backup storage
tar -czf $BACKUP_DIR/storage-{app_name}-$DATE.tar.gz /opt/{app_name}-storage

# Remove old backups (older than 7 days)
find $BACKUP_DIR -name "app-*.tar.gz" -mtime +7 -delete
find $BACKUP_DIR -name "storage-*.tar.gz" -mtime +7 -delete

echo "Backup completed"
```

### Full System Backup

```bash
#!/bin/bash
# /opt/docs/backup-full.sh

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR={backup_directory}

# Backup everything
tar -czf $BACKUP_DIR/full-backup-$DATE.tar.gz \
  /opt/{app_name} \
  /opt/{app_name}-storage \
  /etc/nginx/sites-available \
  /etc/systemd/system/auto-deploy.*

echo "Full backup completed: full-backup-$DATE.tar.gz"
```

---

## Backup Schedule

### Cron Jobs

```bash
# Edit crontab
crontab -e

# Daily database backup at 2 AM
0 2 * * * /opt/docs/backup-database.sh >> /var/log/backup.log 2>&1

# Daily application backup at 3 AM
0 3 * * * /opt/docs/backup-apps.sh >> /var/log/backup.log 2>&1

# Weekly full backup on Sunday at 4 AM
0 4 * * 0 /opt/docs/backup-full.sh >> /var/log/backup.log 2>&1
```

### Systemd Timer (Alternative)

```ini
# /etc/systemd/system/backup-daily.timer
[Unit]
Description=Daily Backup Timer

[Timer]
OnCalendar=*-*-* 02:00:00
Persistent=true
Unit=backup-daily.service

[Install]
WantedBy=timers.target
```

---

## Backup Storage

### Local Storage

```bash
# Backup directory
{backup_directory}

# Check disk space
df -h {backup_directory}

# List backups
ls -lh {backup_directory}

# Check backup sizes
du -sh {backup_directory}/*.tar.gz
```

### Remote Storage (if applicable)

```bash
# Rsync to remote server
rsync -avz {backup_directory}/ user@backup-server:/backups/

# Mount remote storage
mount -t nfs backup-server:/backups /mnt/backup
```

### Cloud Storage (if applicable)

```bash
# Upload to S3
aws s3 sync {backup_directory}/ s3://{bucket-name}/backups/

# Upload to Google Cloud Storage
gsutil rsync -r {backup_directory}/ gs://{bucket-name}/backups/
```

---

## Backup Verification

### Automated Verification

```bash
#!/bin/bash
# /opt/docs/verify-backup.sh

BACKUP_DIR={backup_directory}
DATE=$(date -d "yesterday" +%Y%m%d)

# Check if yesterday's backup exists
if ls $BACKUP_DIR/db-*-$DATE*.sql.gz 1> /dev/null 2>&1; then
    echo "✓ Database backup exists"
    
    # Verify integrity
    gunzip -t $BACKUP_DIR/db-*-$DATE*.sql.gz
    if [ $? -eq 0 ]; then
        echo "✓ Database backup is valid"
    else
        echo "✗ Database backup is corrupted"
        exit 1
    fi
else
    echo "✗ Database backup missing"
    exit 1
fi
```

### Manual Test Restore

```bash
# Create test database
mysql -u root -p -e "CREATE DATABASE test_restore;"

# Restore backup to test database
gunzip < {backup_directory}/db-{database}-20260608.sql.gz | mysql -u root -p test_restore

# Verify data
mysql -u root -p test_restore -e "SHOW TABLES; SELECT COUNT(*) FROM {table_name};"

# Clean up
mysql -u root -p -e "DROP DATABASE test_restore;"
```

---

## Recovery Procedures

### Database Recovery

#### From Local Backup

```bash
# 1. Stop application
cd /opt/{app_name}
docker compose stop

# 2. Restore database
gunzip < {backup_directory}/db-{database}-{date}.sql.gz | mysql -u {user} -p {database}

# 3. Verify restoration
mysql -u {user} -p {database} -e "SHOW TABLES;"

# 4. Start application
docker compose start

# 5. Verify application
curl -f http://127.0.0.1:{port}/health
```

#### From Remote Backup

```bash
# 1. Download backup from remote
rsync -avz user@backup-server:/backups/db-{database}-{date}.sql.gz {backup_directory}/

# 2. Restore database
gunzip < {backup_directory}/db-{database}-{date}.sql.gz | mysql -u {user} -p {database}

# 3. Verify and restart
docker compose restart
```

### Application Recovery

```bash
# 1. Stop container
cd /opt/{app_name}
docker compose down

# 2. Restore application code
tar -xzf {backup_directory}/app-{app_name}-{date}.tar.gz -C /

# 3. Restore storage
tar -xzf {backup_directory}/storage-{app_name}-{date}.tar.gz -C /

# 4. Rebuild and start
docker compose build
docker compose up -d

# 5. Verify
docker ps
curl -f http://127.0.0.1:{port}/health
```

### Full System Recovery

```bash
# 1. Stop all services
docker compose -f /opt/{app_name}/docker-compose.yml down
sudo systemctl stop nginx

# 2. Restore full backup
tar -xzf {backup_directory}/full-backup-{date}.tar.gz -C /

# 3. Start services
sudo systemctl start nginx
cd /opt/{app_name}
docker compose up -d

# 4. Verify all services
docker ps
curl -f http://127.0.0.1:{port}/health
sudo systemctl status nginx
```

---

## Disaster Recovery Plan

### Scenario: Server Failure

**RTO (Recovery Time Objective):** {X hours}
**RPO (Recovery Point Objective):** {Y hours}

#### Recovery Steps

1. **Provision new server** with same specs
2. **Install base software** (Docker, Nginx, etc.)
3. **Restore from backup**
   ```bash
   rsync -avz user@backup-server:/backups/latest/ /opt/
   ```
4. **Restore database** from latest backup
5. **Update DNS** to point to new server (if needed)
6. **Verify all services** are running
7. **Test critical user flows**

### Scenario: Data Corruption

1. **Identify corruption time** from logs
2. **Stop application** to prevent further corruption
3. **Restore database** from backup before corruption
4. **Verify data integrity**
5. **Restart application**
6. **Monitor for issues**

### Scenario: Ransomware Attack

1. **Isolate server** from network immediately
2. **Assess damage** and scope of encryption
3. **Do NOT pay ransom**
4. **Wipe server** and reinstall OS
5. **Restore from offline backup** (before attack)
6. **Patch vulnerability** that allowed attack
7. **Implement additional security measures**

---

## Backup Monitoring

### Check Backup Status

```bash
# List recent backups
ls -lht {backup_directory} | head -20

# Check backup log
tail -f /var/log/backup.log

# Verify backup integrity
/opt/docs/verify-backup.sh
```

### Alerting

{Jelaskan alerting untuk backup failures}

Contoh:
- Email alert if backup fails
- Slack notification on backup completion
- PagerDuty if backup missing for > 24 hours

---

## Backup Retention Policy

| Backup Type | Retention | Storage |
|-------------|-----------|---------|
| Daily Database | 30 days | Local + Remote |
| Daily Application | 7 days | Local |
| Weekly Full | 90 days | Remote |
| Monthly Archive | 1 year | Cloud |

### Cleanup Script

```bash
#!/bin/bash
# /opt/docs/cleanup-backups.sh

BACKUP_DIR={backup_directory}

# Remove daily backups older than 30 days
find $BACKUP_DIR -name "db-*.sql.gz" -mtime +30 -delete

# Remove application backups older than 7 days
find $BACKUP_DIR -name "app-*.tar.gz" -mtime +7 -delete

# Remove full backups older than 90 days
find $BACKUP_DIR -name "full-*.tar.gz" -mtime +90 -delete

echo "Cleanup completed"
```

---

## Security Considerations

### Backup Encryption

```bash
# Encrypt backup
gpg --symmetric --cipher-algo AES256 backup.tar.gz

# Decrypt backup
gpg --decrypt backup.tar.gz.gpg > backup.tar.gz
```

### Access Control

```bash
# Backup directory permissions
chmod 700 {backup_directory}
chown root:root {backup_directory}

# Backup file permissions
chmod 600 {backup_directory}/*.tar.gz
```

### Backup Secrets

{Jelaskan bagaimana backup credentials/secrets dikelola}

Contoh:
- Database password di environment variable
- Cloud storage credentials di ~/.aws/credentials (permission 600)
- Encryption key di secure location, rotated yearly

---

## Testing & Validation

### Quarterly DR Drill

{Jelaskan disaster recovery drill yang dilakukan}

Contoh:
1. Restore full backup ke test server
2. Verify all services running
3. Test critical user flows
4. Measure RTO and RPO
5. Document findings and improvements

### Backup Audit Checklist

- [ ] Daily backups running successfully
- [ ] Backup verification passing
- [ ] Retention policy enforced
- [ ] Offsite backup working
- [ ] Encryption enabled
- [ ] Access control configured
- [ ] Recovery procedures tested
- [ ] Documentation up-to-date

---

**Last Updated:** {YYYY-MM-DD}
**Maintained by:** DevOps Team
