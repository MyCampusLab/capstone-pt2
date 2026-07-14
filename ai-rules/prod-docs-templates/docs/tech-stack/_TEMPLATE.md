# {Application Name} — {Technology Stack}

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Terakhir diperbarui:** {YYYY-MM-DD}

---

## Overview

| Item | Value |
|------|-------|
| Application | {app_name} |
| Technology | {tech_stack} |
| Version | {version} |
| Container | {container_name} |
| Port | {port} |
| Compose File | {compose_path} |

{1-2 paragraf yang menjelaskan apa yang dilakukan aplikasi ini, peranannya dalam sistem, dan teknologi yang digunakan}

---

## Tech Stack Details

### Runtime

| Component | Version | Purpose |
|-----------|---------|---------|
| {runtime} | {version} | {purpose} |
| {framework} | {version} | {purpose} |
| {database_driver} | {version} | {purpose} |

### Dependencies

{List dependencies utama dan versinya}

```
{dependency_1}: {version}
{dependency_2}: {version}
{dependency_3}: {version}
```

---

## Docker Configuration

### Image

```dockerfile
# Base image
FROM {base_image}

# Build commands
{build_commands}

# Runtime
CMD [{cmd}]
```

**Build command:**
```bash
cd /opt/{app_name}
docker build -t {image_name}:{tag} .
```

### Container Settings

```yaml
services:
  {service_name}:
    image: {image_name}:{tag}
    container_name: {container_name}
    restart: unless-stopped
    
    # Resource limits
    deploy:
      resources:
        limits:
          cpus: '{cpu_limit}'
          memory: {memory_limit}
        reservations:
          cpus: '{cpu_reservation}'
          memory: {memory_reservation}
    
    # Security
    cap_drop:
      - ALL
    security_opt:
      - no-new-privileges:true
    
    # Networking
    ports:
      - "{port_mapping}"
    networks:
      - {network_name}
    
    # Volumes
    volumes:
      - {volume_mounts}
    
    # Environment
    env_file:
      - .env
    environment:
      - {env_vars}
```

### Environment Variables

| Variable | Value | Purpose |
|----------|-------|---------|
| {var_1} | {value_1} | {purpose_1} |
| {var_2} | {value_2} | {purpose_2} |

**File location:** `/opt/{app_name}/.env`

---

## Volume Mounts

| Host Path | Container Path | Mode | Purpose |
|-----------|----------------|------|---------|
| {host_path_1} | {container_path_1} | {mode_1} | {purpose_1} |
| {host_path_2} | {container_path_2} | {mode_2} | {purpose_2} |

### Storage Locations

```
/opt/{app_name}/              # Application code
/opt/{app_name}-storage/      # Persistent storage (if separate)
/opt/{app_name}/logs/         # Application logs
/opt/{app_name}/.env          # Environment variables
```

---

## Network Configuration

### Container Network

| Network | Container | IP Range | Purpose |
|---------|-----------|----------|---------|
| {network_name} | {container_name} | {ip_range} | {purpose} |

### Port Mapping

| Host Port | Container Port | Protocol | Bind Address |
|-----------|----------------|----------|--------------|
| {host_port} | {container_port} | {protocol} | {bind_address} |

### Inter-Container Communication

{Jelaskan bagaimana container ini berkomunikasi dengan container lain}

Contoh:
- Communicates with Redis via `{network_name}` network
- Connects to database at `{db_host}:{db_port}`
- Exposes API on port `{port}` for Nginx reverse proxy

---

## Configuration Files

### Main Configuration

```yaml
# /opt/{app_name}/{config_file}
{config_content}
```

### Nginx Configuration (if applicable)

```nginx
# /etc/nginx/sites-available/{app_name}
server {
    listen 80;
    server_name {domain};
    
    location / {
        proxy_pass http://127.0.0.1:{port};
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

---

## Database Configuration

### Connection Details

| Item | Value |
|------|-------|
| Database Type | {db_type} |
| Host | {db_host} |
| Port | {db_port} |
| Database Name | {db_name} |
| Username | {db_user} |
| Password | {stored_in_env} |

### Connection String

```
{connection_string_format}
```

### Migrations

```bash
# Run migrations
docker exec -it {container_name} {migration_command}

# Rollback
docker exec -it {container_name} {rollback_command}
```

---

## Deployment

### Deploy Process

{Jelaskan proses deployment aplikasi ini}

Contoh:
1. Code di-push ke repository
2. Auto-deploy script pull dari git setiap 1 menit
3. Build Docker image baru
4. Restart container dengan image baru
5. Health check verification

### Manual Deploy

```bash
# Stop container
cd /opt/{app_name}
docker compose down

# Pull latest code
git pull origin main

# Build new image
docker compose build

# Start container
docker compose up -d

# Verify
docker ps
docker logs {container_name}
```

### Rollback

```bash
# Rollback to previous version
cd /opt/{app_name}
git checkout {previous_commit}
docker compose build
docker compose up -d
```

---

## Monitoring

### Health Check

```bash
# Check container status
docker ps | grep {container_name}

# Check application health
curl -f http://127.0.0.1:{port}/health

# Check logs
docker logs -f {container_name}
tail -f /opt/{app_name}/logs/{log_file}
```

### Metrics

{Jelaskan metrics yang dimonitor}

- **CPU Usage**: {threshold}
- **Memory Usage**: {threshold}
- **Response Time**: {threshold}
- **Error Rate**: {threshold}

### Log Locations

```
/opt/{app_name}/logs/{log_file}     # Application logs
/var/log/nginx/{access_log}         # Nginx access logs
/var/log/nginx/{error_log}          # Nginx error logs
```

---

## Backup & Restore

### Backup

```bash
# Backup application code
tar -czf backup-{app_name}-$(date +%Y%m%d).tar.gz /opt/{app_name}

# Backup storage
tar -czf backup-{app_name}-storage-$(date +%Y%m%d).tar.gz /opt/{app_name}-storage

# Backup database
mysqldump -u {user} -p {database} > backup-{database}-$(date +%Y%m%d).sql
```

### Restore

```bash
# Restore application code
tar -xzf backup-{app_name}-YYYYMMDD.tar.gz -C /

# Restore storage
tar -xzf backup-{app_name}-storage-YYYYMMDD.tar.gz -C /

# Restore database
mysql -u {user} -p {database} < backup-{database}-YYYYMMDD.sql

# Restart container
cd /opt/{app_name}
docker compose up -d
```

---

## Common Issues & Troubleshooting

### Container Won't Start

**Symptoms:** Container exits immediately after start

**Solutions:**
```bash
# Check logs
docker logs {container_name}

# Check resource usage
docker stats {container_name}

# Check disk space
df -h

# Restart with verbose output
docker compose up
```

### High Memory Usage

**Symptoms:** Container using more memory than expected

**Solutions:**
```bash
# Check memory usage
docker stats {container_name}

# Check for memory leaks
docker exec -it {container_name} {memory_check_command}

# Increase memory limit (edit docker-compose.yml)
# Then:
docker compose up -d
```

### Database Connection Failed

**Symptoms:** Application cannot connect to database

**Solutions:**
```bash
# Check database connectivity
docker exec -it {container_name} {ping_command} {db_host}

# Check database credentials
docker exec -it {container_name} env | grep DB

# Check database server status
systemctl status {db_service}

# Check firewall rules
sudo ufw status
```

---

## Performance Tuning

### Current Settings

| Setting | Value | Notes |
|---------|-------|-------|
| {setting_1} | {value_1} | {notes_1} |
| {setting_2} | {value_2} | {notes_2} |

### Optimization Recommendations

{List rekomendasi optimasi jika diperlukan}

Contoh:
- Increase worker processes based on CPU cores
- Enable caching for frequently accessed data
- Optimize database queries with proper indexing
- Use CDN for static assets

---

## Security Considerations

### Hardening

{List security measures yang diterapkan}

Contoh:
- Container runs as non-root user
- All capabilities dropped except necessary ones
- Read-only filesystem where possible
- Secrets stored in environment variables, not in code
- Regular security updates via base image updates

### Vulnerability Scanning

```bash
# Scan image for vulnerabilities
docker scout cves {image_name}:{tag}

# Check for outdated packages
docker exec -it {container_name} {package_check_command}
```

---

## Useful Commands

### Container Management

```bash
# Start/stop/restart
docker compose up -d
docker compose down
docker compose restart

# View logs
docker logs -f {container_name}
docker logs --tail 100 {container_name}

# Execute command in container
docker exec -it {container_name} sh
docker exec -it {container_name} {specific_command}

# Resource usage
docker stats {container_name}
docker top {container_name}
```

### Application-Specific

```bash
# {app_specific_command_1}
{command_1}

# {app_specific_command_2}
{command_2}
```

---

## References

- **Documentation:** {doc_url}
- **Repository:** {repo_url}
- **Issues:** {issues_url}

---

**Last Updated:** {YYYY-MM-DD}
**Maintained by:** DevOps Team
