# Deployment — {Server Name}

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Terakhir diperbarui:** {YYYY-MM-DD}

---

## Overview

{Jelaskan strategi deployment yang digunakan di server ini}

Contoh:
Server ini menggunakan **pull-based deployment** dengan auto-deploy script yang berjalan setiap 1 menit via systemd timer. Script akan pull code terbaru dari repository, build Docker image, dan restart container jika ada perubahan.

---

## Deployment Strategy

| Item | Value |
|------|-------|
| Strategy | {pull-based / push-based / manual} |
| Automation | {systemd timer / cron / GitHub Actions} |
| Frequency | {every 1 minute / on-demand / manual} |
| Rollback | {git checkout / docker tag / manual} |
| Downtime | {zero-downtime / brief downtime} |

---

## Auto-Deploy Configuration

### Systemd Timer

```ini
# /etc/systemd/system/auto-deploy.timer
[Unit]
Description=Auto Deploy Timer

[Timer]
OnBootSec=1min
OnUnitActiveSec=1min
Unit=auto-deploy.service

[Install]
WantedBy=timers.target
```

### Deploy Script

```bash
# /opt/auto-deploy/auto-deploy.sh
#!/bin/bash
{script_content}
```

### Enable/Disable Auto-Deploy

```bash
# Check status
systemctl status auto-deploy.timer

# Enable
sudo systemctl enable auto-deploy.timer
sudo systemctl start auto-deploy.timer

# Disable (maintenance mode)
sudo systemctl stop auto-deploy.timer
sudo systemctl disable auto-deploy.timer

# Manual trigger
sudo systemctl start auto-deploy.service
```

---

## Initial Server Setup (Pertama Kali — Gantikan SFTP/Drag-Drop)

> **Jika sebelumnya deploy via SFTP/FileZilla drag-drop, ikuti prosedur ini untuk migrasi ke git-based deploy.**

### Step 1: Clone Repository ke Server

```bash
# 1. SSH to server
ssh {user}@{server}

# 2. Backup existing code (SAFETY FIRST!)
sudo cp -r /var/www/{app_name} /var/www/{app_name}.backup.$(date +%Y%m%d)

# 3. Clone dari repository
cd /var/www
sudo git clone {CLONE_URL} {app_name}

# 4. Restore .env dan uploads dari backup
sudo cp /var/www/{app_name}.backup.*/.env /var/www/{app_name}/.env
sudo cp -r /var/www/{app_name}.backup.*/storage/app/public /var/www/{app_name}/storage/app/ 2>/dev/null || true

# 5. Set permissions
sudo chown -R www-data:www-data /var/www/{app_name}
```

### Step 2: Setup Git Authentication di Server

> **Pilih salah satu. Lihat [repository-access.md](./repository-access.md) untuk detail.**

**Opsi A: Deploy Key (SSH — Recommended)**

```bash
ssh-keygen -t ed25519 -C "deploy@{server_name}" -f ~/.ssh/id_ed25519_deploy -N ""
cat ~/.ssh/id_ed25519_deploy.pub
# Tambahkan public key ke GitHub/GitLab sebagai Deploy Key
ssh -T git@github.com  # Test koneksi
```

**Opsi B: Token HTTPS (Jika SSH diblokir)**

```bash
git config --global credential.helper store
git clone https://{username}:{token}@github.com/{owner}/{repo}.git /var/www/{app_name}
```

### Step 3: Verifikasi Setup

```bash
cd /var/www/{app_name}
git fetch origin
git log --oneline -5
echo "SUCCESS: Git-based deploy ready"
```

---

## Manual Deployment

### Application Deploy Steps

```bash
# 1. SSH to server
ssh {user}@{server}

# 2. Navigate to application
cd /var/www/{app_name}

# 3. Pull latest code
git pull origin main

# 4. Build Docker image
docker compose build

# 5. Restart container
docker compose up -d

# 6. Verify
docker ps
docker logs {container_name}
curl -f http://127.0.0.1:{port}/health
```

### Database Migration

```bash
# Run migrations
docker exec -it {container_name} {migration_command}

# Verify migration
docker exec -it {container_name} {verify_command}

# Rollback if needed
docker exec -it {container_name} {rollback_command}
```

### Nginx Configuration Update

```bash
# Edit configuration
sudo nano /etc/nginx/sites-available/{app_name}

# Test configuration
sudo nginx -t

# Reload Nginx
sudo systemctl reload nginx

# Verify
curl -I https://{domain}
```

---

## Deployment Checklist

### Pre-Deployment

- [ ] Code tested in staging environment
- [ ] Database migrations reviewed and tested
- [ ] Backup database before deployment
- [ ] Notify team about deployment window
- [ ] Check disk space and resources

### During Deployment

- [ ] Pull latest code from repository
- [ ] Build Docker image successfully
- [ ] Run database migrations
- [ ] Restart container
- [ ] Verify application health

### Post-Deployment

- [ ] Test critical user flows
- [ ] Monitor logs for errors
- [ ] Check resource usage (CPU, memory, disk)
- [ ] Verify monitoring alerts are working
- [ ] Update documentation if needed
- [ ] Write deployment report

---

## Rollback Procedures

### Application Rollback

```bash
# 1. Stop current container
cd /opt/{app_name}
docker compose down

# 2. Checkout previous version
git checkout {previous_commit}

# 3. Rebuild image
docker compose build

# 4. Start container
docker compose up -d

# 5. Verify
docker ps
docker logs {container_name}
```

### Database Rollback

```bash
# Option 1: Run rollback migration
docker exec -it {container_name} {rollback_command}

# Option 2: Restore from backup
mysql -u {user} -p {database} < backup-{date}.sql
```

### Emergency Rollback

{Jelaskan prosedur rollback darurat jika deploy gagal total}

```bash
# Stop all services
docker compose down
sudo systemctl stop nginx

# Restore from backup
/opt/docs/backup-apps.sh restore {backup_date}

# Start services
sudo systemctl start nginx
docker compose up -d
```

---

## Blue-Green Deployment (if applicable)

{Jelaskan jika menggunakan blue-green deployment}

### Setup

```
Blue (Current):  /opt/{app_name}-blue/
Green (New):     /opt/{app_name}-green/
```

### Switch Traffic

```bash
# 1. Deploy to green environment
cd /opt/{app_name}-green
git pull origin main
docker compose build
docker compose up -d

# 2. Test green environment
curl -f http://127.0.0.1:{green_port}/health

# 3. Switch Nginx to green
sudo sed -i 's/blue/green/g' /etc/nginx/sites-available/{app_name}
sudo nginx -t
sudo systemctl reload nginx

# 4. Monitor and verify
tail -f /var/log/nginx/access.log
```

---

## Canary Deployment (if applicable)

{Jelaskan jika menggunakan canary deployment}

### Traffic Split

```nginx
# 90% to stable, 10% to canary
upstream backend {
    server stable:3000 weight=9;
    server canary:3000 weight=1;
}
```

---

## Environment Management

### Environment Variables

```bash
# Location
/opt/{app_name}/.env

# Update variables
nano /opt/{app_name}/.env

# Restart container to apply
cd /opt/{app_name}
docker compose up -d
```

### Secrets Management

{Jelaskan bagaimana secrets dikelola}

Contoh:
- Secrets disimpan di `.env` file dengan permission 600
- Tidak di-commit ke git
- Backup encrypted di secure location
- Rotated setiap 90 hari

---

## Deployment Windows

| Window | Time | Purpose |
|--------|------|---------|
| Regular Deploy | {time} | Normal deployments |
| Maintenance Window | {time} | Major updates, migrations |
| Emergency Deploy | Anytime | Critical bug fixes, security patches |

---

## Monitoring During Deployment

### What to Monitor

- **Application Logs**: `docker logs -f {container_name}`
- **Nginx Logs**: `tail -f /var/log/nginx/error.log`
- **Resource Usage**: `docker stats`, `htop`
- **Response Time**: `curl -w "@curl-format.txt" -o /dev/null -s https://{domain}`
- **Error Rate**: Check logs for 5xx errors

### Alerting

{Jelaskan alerting yang aktif selama deployment}

Contoh:
- Slack notification on deployment start
- Email alert if error rate > 5%
- PagerDuty if service down > 5 minutes

---

## Common Deployment Issues

### Build Failed

**Symptoms:** Docker build fails

**Solutions:**
```bash
# Check build logs
docker compose build --no-cache

# Check disk space
df -h

# Check Docker daemon
systemctl status docker

# Clean Docker cache
docker system prune -a
```

### Container Won't Start

**Symptoms:** Container exits immediately

**Solutions:**
```bash
# Check logs
docker logs {container_name}

# Check environment variables
docker exec -it {container_name} env

# Check volume mounts
docker inspect {container_name} | grep -A 10 Mounts

# Start in foreground for debugging
docker compose up
```

### Database Migration Failed

**Symptoms:** Application error after migration

**Solutions:**
```bash
# Check migration status
docker exec -it {container_name} {status_command}

# Rollback migration
docker exec -it {container_name} {rollback_command}

# Restore from backup if needed
mysql -u {user} -p {database} < backup.sql
```

---

## Deployment Scripts

### Quick Deploy

```bash
#!/bin/bash
# /opt/docs/deploy-quick.sh

APP_NAME=$1
BRANCH=${2:-main}

cd /opt/$APP_NAME
git pull origin $BRANCH
docker compose build
docker compose up -d
docker ps | grep $APP_NAME
```

### Full Deploy with Migration

```bash
#!/bin/bash
# /opt/docs/deploy-full.sh

APP_NAME=$1
BRANCH=${2:-main}

# Backup database
/opt/docs/backup-db.sh $APP_NAME

# Deploy
cd /opt/$APP_NAME
git pull origin $BRANCH
docker compose build
docker compose up -d

# Run migrations
docker exec -it ${APP_NAME} {migration_command}

# Verify
curl -f http://127.0.0.1:{port}/health
```

---

**Last Updated:** {YYYY-MM-DD}
**Maintained by:** DevOps Team
