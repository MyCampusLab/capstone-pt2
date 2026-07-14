# Database Backup Setup — {Database Name}

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Output Location:** `{apps|backend|frontend}/docs/operations/scripts/` — **INSIDE git repo. DILARANG menulis credential aktual (password, token, API key, server IP). Gunakan referensi .env atau prod-docs/.**
> **Purpose:** Dokumentasi setup automatic database backup

---

## Overview

**Database:** {Nama database}  
**Type:** {MySQL / PostgreSQL / MongoDB / SQLite}  
**Backup Schedule:** {cron expression, contoh: 0 2 * * *} (daily at 2 AM)  
**Retention:** {jumlah hari, contoh: 30 days}  
**Storage:** {Local / S3 / MinIO / FTP}

---

## Prerequisites

- Database credentials sudah dikonfigurasi di `.env`
- User backup punya read access ke database
- Storage destination sudah disiapkan (local path atau cloud credentials)
- `gzip` atau compression tool sudah terinstall

**Check prerequisites:**
```bash
# Check database connection (credentials from .env)
source {project_path}/.env && mysql -u$DB_USERNAME -p$DB_PASSWORD -e "SHOW DATABASES;"

# Check compression tool
which gzip
which bzip2
```

---

## Backup Script

**File:** `{project_path}/docs/operations/scripts/backup-database.sh`

```bash
#!/bin/bash
# Database backup script for {database_name}

# Load environment
source {project_path}/.env

# Configuration
BACKUP_DIR="{backup_directory}"
DATE=$(date +%Y%m%d_%H%M%S)
DB_NAME="$DB_DATABASE"
DB_USER="$DB_USERNAME"
DB_PASS="$DB_PASSWORD"
DB_HOST="${DB_HOST:-localhost}"
RETENTION_DAYS={retention_days}

# Create backup directory if not exists
mkdir -p $BACKUP_DIR

# Backup filename
BACKUP_FILE="$BACKUP_DIR/$DB_NAME-$DATE.sql.gz"

# Perform backup
echo "Starting backup: $DB_NAME at $(date)"

# MySQL/MariaDB
mysqldump -h$DB_HOST -u$DB_USER -p$DB_PASS --single-transaction --routines --triggers $DB_NAME | gzip > $BACKUP_FILE

# PostgreSQL (uncomment if using PostgreSQL)
# PGPASSWORD=$DB_PASS pg_dump -h$DB_HOST -U$DB_USER -Fc $DB_NAME | gzip > $BACKUP_FILE

# Check if backup successful
if [ $? -eq 0 ]; then
    echo "Backup successful: $BACKUP_FILE"
    
    # Get file size
    SIZE=$(du -h $BACKUP_FILE | cut -f1)
    echo "Backup size: $SIZE"
    
    # Remove old backups (older than RETENTION_DAYS)
    echo "Cleaning up backups older than $RETENTION_DAYS days..."
    find $BACKUP_DIR -name "*.sql.gz" -type f -mtime +$RETENTION_DAYS -delete
    
    # List remaining backups
    echo "Remaining backups:"
    ls -lh $BACKUP_DIR/*.sql.gz | tail -10
else
    echo "ERROR: Backup failed!"
    exit 1
fi

echo "Backup completed at $(date)"
```

**Make executable:**
```bash
chmod +x {project_path}/docs/operations/scripts/backup-database.sh
```

---

## Setup Steps

### 1. Create backup directory

```bash
mkdir -p {backup_directory}
chmod 700 {backup_directory}
```

### 2. Test backup script manually

```bash
bash {project_path}/docs/operations/scripts/backup-database.sh
```

**Expected output:**
```
Starting backup: {database_name} at {date}
Backup successful: {backup_directory}/{database_name}-{date}.sql.gz
Backup size: {size}
Cleaning up backups older than {retention_days} days...
Remaining backups:
{list of backup files}
Backup completed at {date}
```

### 3. Setup cronjob

```bash
crontab -e
```

**Add entry:**
```bash
0 2 * * * {project_path}/docs/operations/scripts/backup-database.sh >> {project_path}/storage/logs/backup.log 2>&1
```

### 4. Verify cronjob

```bash
crontab -l
```

---

## Verification

**Check backup files:**
```bash
ls -lh {backup_directory}/*.sql.gz
```

**Test restore (IMPORTANT - test on separate database):**
```bash
# Create test database (credentials from .env)
source {project_path}/.env && mysql -u$DB_USERNAME -p$DB_PASSWORD -e "CREATE DATABASE ${DB_DATABASE}_test;"

# Restore backup
gunzip < {backup_file}.sql.gz | mysql -u$DB_USERNAME -p$DB_PASSWORD ${DB_DATABASE}_test

# Verify data
mysql -u$DB_USERNAME -p$DB_PASSWORD ${DB_DATABASE}_test -e "SHOW TABLES;"

# Cleanup test database
mysql -u$DB_USERNAME -p$DB_PASSWORD -e "DROP DATABASE ${DB_DATABASE}_test;"
```

**Check backup logs:**
```bash
tail -f {project_path}/storage/logs/backup.log
```

---

## Cloud Storage (Optional)

### AWS S3

**Install AWS CLI:**
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

**Configure AWS credentials:**
```bash
aws configure
# AWS Access Key ID: See .env: AWS_ACCESS_KEY_ID
# AWS Secret Access Key: See .env: AWS_SECRET_ACCESS_KEY
# Default region name: {your_region}
# Default output format: json
```

**Add to backup script:**
```bash
# After local backup, upload to S3
aws s3 cp $BACKUP_FILE s3://{bucket_name}/backups/

# Remove old backups from S3 (older than RETENTION_DAYS)
aws s3 ls s3://{bucket_name}/backups/ | awk '{print $4}' | grep ".sql.gz" | while read file; do
    FILE_DATE=$(echo $file | grep -oP '\d{8}')
    TODAY=$(date +%Y%m%d)
    DAYS_OLD=$(( ($(date -d $Today +%s) - $(date -d $FILE_DATE +%s)) / 86400 ))
    
    if [ $DAYS_OLD -gt $RETENTION_DAYS ]; then
        aws s3 rm s3://{bucket_name}/backups/$file
    fi
done
```

### MinIO

**Install MinIO Client:**
```bash
wget https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x mc
sudo mv mc /usr/local/bin/
```

**Configure MinIO:**
```bash
# Credentials from .env: MINIO_ACCESS_KEY, MINIO_SECRET_KEY
mc alias set myminio ${MINIO_ENDPOINT} ${MINIO_ACCESS_KEY} ${MINIO_SECRET_KEY}
```

**Add to backup script:**
```bash
# Upload to MinIO
mc cp $BACKUP_FILE myminio/{bucket_name}/backups/

# Remove old backups
mc ls myminio/{bucket_name}/backups/ | awk '{print $5}' | grep ".sql.gz" | while read file; do
    # Similar logic as S3
done
```

---

## Troubleshooting

### Backup file kosong (0 bytes)

**Symptom:** Backup file created but size is 0

**Solutions:**
1. Check database credentials (from .env):
   ```bash
   source {project_path}/.env && mysql -u$DB_USERNAME -p$DB_PASSWORD -h$DB_HOST -e "SHOW DATABASES;"
   ```

2. Check disk space:
   ```bash
   df -h
   ```

3. Check mysqldump errors (credentials from .env):
   ```bash
   source {project_path}/.env && mysqldump -u$DB_USERNAME -p$DB_PASSWORD $DB_DATABASE > test.sql 2> error.log
   cat error.log
   ```

### Permission denied

**Symptom:** Script fails with "Permission denied"

**Solution:**
```bash
# Check script permissions
ls -la {project_path}/docs/operations/scripts/backup-database.sh

# Fix permissions
chmod +x {project_path}/docs/operations/scripts/backup-database.sh

# Check backup directory permissions
ls -la {backup_directory}

# Fix directory permissions
chmod 700 {backup_directory}
```

### Cronjob tidak jalan

**Symptom:** Backup not created at scheduled time

**Solutions:**
1. Check cron is running:
   ```bash
   sudo systemctl status cron
   ```

2. Check crontab:
   ```bash
   crontab -l
   ```

3. Check cron logs:
   ```bash
   grep CRON /var/log/syslog | grep backup
   ```

4. Test manually:
   ```bash
   bash {project_path}/docs/operations/scripts/backup-database.sh
   ```

### Old backups tidak terhapus

**Symptom:** Backup directory growing too large

**Solution:**
```bash
# Check retention logic in script
nano {project_path}/docs/operations/scripts/backup-database.sh

# Manual cleanup
find {backup_directory} -name "*.sql.gz" -type f -mtime +{retention_days} -delete
```

---

## Maintenance

### Test restore regularly

**IMPORTANT:** Test backup restore at least once a month

```bash
# Monthly restore test
bash {project_path}/docs/operations/scripts/test-backup-restore.sh
```

### Monitor backup size

```bash
# Check total backup size
du -sh {backup_directory}

# Check individual backup sizes
ls -lh {backup_directory}/*.sql.gz
```

### Update retention policy

```bash
nano {project_path}/docs/operations/scripts/backup-database.sh
# Update RETENTION_DAYS variable
```

---

## Auto-Setup Script

**Script:** `{project_path}/docs/operations/scripts/setup-backup.sh`

```bash
#!/bin/bash
# Setup automatic database backup

PROJECT_PATH="{project_path}"
BACKUP_DIR="{backup_directory}"
CRON_EXPRESSION="{cron_expression}"

# Create backup directory
mkdir -p $BACKUP_DIR
chmod 700 $BACKUP_DIR

# Make backup script executable
chmod +x $PROJECT_PATH/docs/operations/scripts/backup-database.sh

# Backup current crontab
crontab -l > /tmp/crontab-backup-$(date +%Y%m%d_%H%M%S).txt

# Add backup cronjob
(crontab -l 2>/dev/null; echo "$CRON_EXPRESSION $PROJECT_PATH/docs/operations/scripts/backup-database.sh >> $PROJECT_PATH/storage/logs/backup.log 2>&1") | crontab -

# Test backup
echo "Testing backup..."
bash $PROJECT_PATH/docs/operations/scripts/backup-database.sh

# Show crontab
echo "Updated crontab:"
crontab -l

echo "Backup setup completed"
```

**Run (auto-setup mode):**
```bash
bash {project_path}/docs/operations/scripts/setup-backup.sh
```

**Run (manual-setup mode):**
```bash
# Copy commands dari script dan jalankan manual
```
