# Changelog — {Server Name}

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Terakhir diperbarui:** {YYYY-MM-DD}

---

## Overview

File ini mencatat **semua perubahan teknologi, arsitektur, dan konfigurasi** yang dilakukan di server ini. Setiap perubahan harus didokumentasikan dengan tanggal, deskripsi, alasan, dan dampak.

**Format Entry:**
```markdown
### YYYY-MM-DD — {Judul Perubahan}
**Kategori:** {Architecture/Tech Stack/Security/Operations/Configuration}
**Perubahan:** {Deskripsi singkat apa yang berubah}
**Alasan:** {Mengapa perubahan ini dilakukan}
**Dampak:** {Dampak terhadap sistem/users/performa}
**Rollback:** {Cara kembali ke kondisi sebelumnya jika diperlukan}
```

---

## Recent Changes

### 2026-06-09 — Initial Setup

**Kategori:** Architecture
**Perubahan:** Initial server setup and documentation
**Alasan:** Setting up production server documentation system
**Dampak:** Baseline documentation established
**Rollback:** N/A

---

## Change Categories

### Architecture Changes

{Catat perubahan arsitektur seperti: penambahan service baru, perubahan topology, scaling, dll}

#### Template:
```markdown
### YYYY-MM-DD — {Judul}
**Kategori:** Architecture
**Perubahan:** {Contoh: Added Redis cache layer for session management}
**Alasan:** {Contoh: Improve session performance and enable horizontal scaling}
**Dampak:** {Contoh: Session retrieval 10x faster, can scale app horizontally}
**Rollback:** {Contoh: Remove Redis, revert to file-based sessions}
**Files Changed:**
- /opt/{app_name}/docker-compose.yml
- /opt/{app_name}/.env
- /etc/nginx/sites-available/{app_name}
```

### Tech Stack Changes

{Catat perubahan tech stack seperti: upgrade versi, ganti library, tambah dependency, dll}

#### Template:
```markdown
### YYYY-MM-DD — {Judul}
**Kategori:** Tech Stack
**Perubahan:** {Contoh: Upgraded Node.js from 18 to 22}
**Alasan:** {Contoh: LTS support, performance improvements, new features}
**Dampak:** {Contoh: 15% performance improvement, requires testing}
**Rollback:** {Contoh: Downgrade Node.js version in Dockerfile, rebuild image}
**Files Changed:**
- /opt/{app_name}/Dockerfile
- /opt/{app_name}/package.json
```

### Security Changes

{Catat perubahan security seperti: hardening, patch, firewall rules, dll}

#### Template:
```markdown
### YYYY-MM-DD — {Judul}
**Kategori:** Security
**Perubahan:** {Contoh: Added rate limiting to login endpoint}
**Alasan:** {Contoh: Prevent brute force attacks}
**Dampak:** {Contoh: Max 5 login attempts per minute per IP}
**Rollback:** {Contoh: Remove rate limit from nginx config}
**Files Changed:**
- /etc/nginx/sites-available/{app_name}
- /etc/nginx/snippets/security.conf
```

### Operations Changes

{Catat perubahan operational seperti: backup strategy, monitoring, deployment, dll}

#### Template:
```markdown
### YYYY-MM-DD — {Judul}
**Kategori:** Operations
**Perubahan:** {Contoh: Changed backup schedule from daily to hourly}
**Alasan:** {Contoh: Reduce potential data loss from 24h to 1h}
**Dampak:** {Contoh: More storage usage, but better RPO}
**Rollback:** {Contoh: Revert crontab to daily schedule}
**Files Changed:**
- /etc/cron.d/backup
- /opt/docs/backup-database.sh
```

### Configuration Changes

{Catat perubahan konfigurasi seperti: environment variables, resource limits, dll}

#### Template:
```markdown
### YYYY-MM-DD — {Judul}
**Kategori:** Configuration
**Perubahan:** {Contoh: Increased container memory limit from 2GB to 4GB}
**Alasan:** {Contoh: Application experiencing OOM errors under load}
**Dampak:** {Contoh: More stable application, higher resource usage}
**Rollback:** {Contoh: Reduce memory limit back to 2GB}
**Files Changed:**
- /opt/{app_name}/docker-compose.yml
```

---

## Change Log History

### 2026

#### June

| Date | Category | Change | Impact |
|------|----------|--------|--------|
| 2026-06-09 | Architecture | Initial setup | Baseline established |

#### May

| Date | Category | Change | Impact |
|------|----------|--------|--------|
| | | | |

#### April

| Date | Category | Change | Impact |
|------|----------|--------|--------|
| | | | |

---

## Major Changes Archive

{Pindahkan perubahan lama (> 6 bulan) ke sini untuk menjaga file tetap readable}

### 2025

{Archive changes from 2025}

---

## Change Review Process

### Before Making Changes

1. **Document the plan** in this file (add entry with status: PLANNED)
2. **Test in staging** if possible
3. **Backup current state** before making changes
4. **Notify team** about the change

### After Making Changes

1. **Update this file** with actual changes made
2. **Verify the change** worked as expected
3. **Monitor for issues** for 24-48 hours
4. **Update related documentation** (architecture, tech-stack, operations)

### Change Approval

| Change Type | Approval Required |
|-------------|-------------------|
| Configuration (minor) | Self-approve |
| Configuration (major) | DevOps Lead |
| Tech Stack | Backend Lead + DevOps Lead |
| Architecture | Full team review |
| Security | Security Lead + DevOps Lead |

---

## Change Statistics

### Changes by Category (Last 6 Months)

| Category | Count | Percentage |
|----------|-------|------------|
| Architecture | {count} | {%} |
| Tech Stack | {count} | {%} |
| Security | {count} | {%} |
| Operations | {count} | {%} |
| Configuration | {count} | {%} |
| **Total** | **{total}** | **100%** |

### Changes by Month

| Month | Count |
|-------|-------|
| 2026-06 | {count} |
| 2026-05 | {count} |
| 2026-04 | {count} |
| 2026-03 | {count} |
| 2026-02 | {count} |
| 2026-01 | {count} |

---

## Related Documentation

- **Architecture:** [architecture/overview.md](architecture/overview.md)
- **Tech Stack:** [tech-stack/](tech-stack/)
- **Operations:** [operations/](operations/)
- **Task Reports:** [../reports-agents/](../reports-agents/)

---

## Contributing

When you make changes to the server:

1. **Add entry** to this file following the template format
2. **Be specific** about what changed and why
3. **Include rollback procedure** if applicable
4. **Update related documentation** files
5. **Link to task report** if applicable

This helps maintain a clear history of how the server evolved over time.

---

**Last Updated:** {YYYY-MM-DD}
**Maintained by:** DevOps Team
