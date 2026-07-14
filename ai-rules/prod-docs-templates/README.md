# Production Server Documentation Template

> **IMMUTABLE — AI TIDAK BOLEH mengubah file ini. Ini adalah TEMPLATE. AI membuat output di prod-docs/ dari template ini.**

> **Status:** Template untuk dokumentasi server production
> **Purpose:** Standardized documentation system untuk AI agent dan tim DevOps yang mengelola server production

---

## Overview

Template ini menyediakan **struktur dokumentasi yang komprehensif** untuk server production. Dirancang agar AI agent dan tim teknis dapat dengan cepat memahami kondisi server, melakukan troubleshooting, dan melakukan perubahan dengan aman.

**Target Users:**
- AI Agent (CommandCode, dll) yang melakukan maintenance server
- DevOps Engineers
- System Administrators
- Backend Developers yang perlu deploy/debug

---

## Quick Start

### 1. Copy Template ke Server

```bash
# Di local machine (docs-ai repository)
scp -r prod-docs/ user@server:/root/

# Atau menggunakan rsync
rsync -avz prod-docs/ user@server:/root/
```

### 2. SSH ke Server dan Rename

```bash
ssh user@server

# Rename folder
cd /root
mv prod-docs docs-ai

# Set permissions
chmod -R 755 docs-ai
```

### 3. Fill in Server Information

Edit file-file berikut dengan informasi server yang sebenarnya:

```bash
# Edit AGENTS.md - Update server info di bagian atas
nano docs-ai/AGENTS.md

# Edit docs/README.md - Update index dengan informasi server
nano docs-ai/docs/README.md
```

### 4. Fill in Documentation

Ikuti checklist berikut untuk mengisi dokumentasi:

#### Phase 1: Basic Setup (Hari 1)
- [ ] Update `AGENTS.md` dengan server name, IP, domain
- [ ] Update `docs/README.md` dengan quick reference
- [ ] Fill `docs/architecture/overview.md` dengan arsitektur server
- [ ] Fill `docs/architecture/network-topology.md` dengan network setup

#### Phase 2: Tech Stack Documentation (Hari 2-3)
- [ ] Copy `docs/tech-stack/_TEMPLATE.md` untuk setiap aplikasi
- [ ] Rename ke nama aplikasi (e.g., `besma-laravel.md`, `nginx.md`)
- [ ] Fill in setiap file dengan informasi komponen

#### Phase 3: Operations Documentation (Hari 3-4)
- [ ] Fill `docs/operations/deployment.md` dengan deployment process
- [ ] Fill `docs/operations/backup.md` dengan backup strategy
- [ ] Fill `docs/operations/monitoring.md` dengan monitoring setup
- [ ] Fill `docs/operations/security.md` dengan security measures

#### Phase 4: Troubleshooting & History (Hari 4-5)
- [ ] Fill `docs/troubleshooting.md` dengan common issues
- [ ] Initialize `docs/changelog.md` dengan initial setup entry
- [ ] Initialize `reports-agents/changelog.md` untuk audit log

---

##  Integrasi dengan Development Documentation (dev-docs/)

**Template ini tidak berdiri sendiri.** Ada informasi dari development yang harus mengalir ke production.

### Konsep Bridge Document

`prod-docs/` dan `dev-docs/` terhubung melalui **bridge document**:

```
dev-docs/ (development)          prod-docs/ (production)
├── ai/PROJECT_CONTEXT.md   →    ├── docs/tech-stack/*.md
├── architecture/           →    ├── docs/architecture/overview.md
├── deployment/             →    ├── docs/operations/deployment.md
├── operations/             →    ├── docs/operations/*.md
├── security/README.md      →    └── docs/operations/security.md
└── deployment/
    └── production-readiness.md ← BRIDGE DOCUMENT (checklist lengkap)
```

**File kunci:** `ai-rules/deployment/production-readiness.md`
- Berisi semua informasi yang harus di-transfer dari development ke production
- Checklist lengkap requirements server, tech stack, architecture, security
- Step-by-step deployment process

### Skenario 1: AI Agent yang Sama (Development + Deployment)

Jika AI agent yang mengerjakan development juga diminta setup server:

```bash
# 1. Di project repository (local)
cd /path/to/project
cat ai-rules/deployment/production-readiness.md  # Baca checklist

# 2. SSH ke server production
ssh user@server

# 3. Setup server sesuai checklist
# AI sudah punya konteks dari dev-docs, tinggal execute
```

**Keuntungan:**
- AI sudah paham tech stack, architecture, security requirements
- Tidak perlu transfer knowledge manual
- Lebih cepat dan akurat

### Skenario 2: AI Agent Berbeda (Hanya Deployment/Operations)

Jika AI agent hanya handle server (tidak terlibat development):

```bash
# 1. Minta dari development team:
#    - production-readiness.md
#    - .env.example
#    - docker-compose.yml
#    - Application repository access

# 2. Baca production-readiness.md
cat production-readiness.md

# 3. Setup server sesuai checklist
# AI mengikuti step-by-step dari dokumen
```

**Keuntungan:**
- Tidak perlu akses ke dev-docs/
- Semua informasi sudah di-extract ke satu file
- Bisa di-handover ke tim operations

### Informasi yang Harus Di-Transfer

| Kategori | Sumber (dev-docs) | Target (prod-docs) |
|----------|-------------------|-------------------|
| **Tech Stack** | `ai/PROJECT_CONTEXT.md` | `docs/tech-stack/*.md` |
| **Architecture** | `architecture/` | `docs/architecture/overview.md` |
| **Database** | `architecture/database.md` | `docs/tech-stack/database.md` |
| **Deployment** | `deployment/` | `docs/operations/deployment.md` |
| **Operations** | `operations/` | `docs/operations/*.md` |
| **Security** | `security/README.md` | `docs/operations/security.md` |
| **Environment** | `.env.example` (repo) | `docs/operations/deployment.md` |

### Checklist Pre-Deployment

**Sebelum mulai setup server, pastikan sudah punya:**

- [ ] `production-readiness.md` dari development team
- [ ] Application repository access
- [ ] `.env.example` untuk referensi environment variables
- [ ] `docker-compose.yml` atau deployment configuration
- [ ] Domain name yang akan digunakan
- [ ] SSL certificate strategy
- [ ] Backup strategy
- [ ] Monitoring strategy

**Jika ada informasi yang kurang, TANYA ke development team sebelum lanjut.**

### Workflow Lengkap

```
┌─────────────────────────────────────────────────────────────┐
│  DEVELOPMENT (dev-docs/)                                     │
│  ├── AI mengerjakan coding                                  │
│  ├── Update dev-docs/ setiap task                           │
│  └── Buat production-readiness.md sebelum launch            │
└─────────────────────────────────────────────────────────────┘
                            ↓
                    production-readiness.md
                    (bridge document)
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  PRODUCTION (prod-docs/)                                     │
│  ├── AI/DevOps baca production-readiness.md                 │
│  ├── Setup server sesuai checklist                          │
│  ├── Fill prod-docs/ dengan informasi aktual server         │
│  └── Maintain server dengan dokumentasi lengkap             │
└─────────────────────────────────────────────────────────────┘
```

---

## Structure

```
prod-docs/
├── README.md                              # ← File ini (cara pakai template)
├── AGENTS.md                              # Entry point untuk AI agent
├── docs/
│   ├── README.md                          # Index dokumentasi teknis
│   ├── changelog.md                       # Log perubahan teknologi/arsitektur
│   ├── troubleshooting.md                 # Common issues & solutions
│   ├── architecture/
│   │   ├── overview.md                    # Arsitektur umum server
│   │   └── network-topology.md            # Network setup & routing
│   ├── tech-stack/
│   │   ├── _TEMPLATE.md                   # Template untuk dokumentasi komponen
│   │   ├── {app-1}.md                     # Dokumentasi aplikasi 1
│   │   ├── {app-2}.md                     # Dokumentasi aplikasi 2
│   │   ├── nginx.md                       # Dokumentasi Nginx
│   │   ├── docker.md                      # Dokumentasi Docker
│   │   └── database.md                    # Dokumentasi Database
│   └── operations/
│       ├── deployment.md                  # Deployment process
│       ├── backup.md                      # Backup strategy
│       ├── monitoring.md                  # Monitoring & alerting
│       └── security.md                    # Security hardening
└── reports-agents/
    ├── changelog.md                       # Audit log semua tasks
    ├── _TASK_TEMPLATE.md                  # Template laporan task
    ├── _DAILY_SUMMARY_TEMPLATE.md         # Template daily summary
    └── YYYY-MM-DD/                        # Folder per tanggal
        ├── 00-summary.md                  # Daily summary
        └── {task-name}.md                 # Laporan task detail
```

---

## Key Features

### 1. AI Agent Integration

**AGENTS.md** adalah entry point untuk AI agent. File ini berisi:
- Server information (nama, IP, domain)
- Rules dan protocols yang harus diikuti AI
- Safety guidelines (READ-FIRST, SAFETY FIRST)
- Documentation update checklist
- Format laporan yang wajib diikuti

AI agent akan membaca file ini di setiap sesi baru dan mengikuti rules yang didefinisikan.

### 2. Comprehensive Documentation

**docs/** berisi dokumentasi teknis lengkap:
- **Architecture:** Overview sistem dan network topology
- **Tech Stack:** Dokumentasi per komponen (aplikasi, database, web server, dll)
- **Operations:** Deployment, backup, monitoring, security
- **Troubleshooting:** Common issues dan solusinya
- **Changelog:** History perubahan teknologi dan arsitektur

### 3. Task Reporting System

**reports-agents/** berisi audit log semua task:
- **changelog.md:** Index semua task dengan status dan link ke detail
- **YYYY-MM-DD/:** Folder per tanggal berisi laporan detail
- **00-summary.md:** Daily summary setiap hari ada task
- **{task-name}.md:** Laporan detail per task dengan format standar

### 4. Safety First Approach

Template ini menekankan **safety first** dengan:
- READ-FIRST protocol (wajib baca docs sebelum action)
- Backup before change (wajib backup sebelum modify)
- Test after change (wajib verify setelah perubahan)
- Rollback procedures (wajib dokumentasikan cara rollback)
- Documentation updates (wajib update docs setelah task)

---

## Documentation Guidelines

### For AI Agents

**WAJIB baca sebelum setiap task:**
1. `AGENTS.md` - Rules dan protocols
2. `docs/README.md` - Index dokumentasi
3. `reports-agents/changelog.md` - Audit log
4. File tech-stack terkait komponen yang akan diubah

**WAJIB lakukan setelah setiap task:**
1. Tulis laporan di `reports-agents/YYYY-MM-DD/{task-name}.md`
2. Update `reports-agents/changelog.md` dengan entry baru
3. Update `docs/changelog.md` jika ada perubahan teknologi
4. Update file docs terkait (lihat checklist di AGENTS.md)
5. Buat `00-summary.md` jika ada task hari itu

### For Human Team Members

**Best practices:**
- Review task reports secara berkala
- Update troubleshooting.md saat menemukan issue baru
- Maintain changelog.md untuk track perubahan besar
- Use templates untuk konsistensi laporan
- Verify backups working secara rutin

---

## Templates

### Task Report Template

**File:** `reports-agents/_TASK_TEMPLATE.md`

Gunakan template ini untuk setiap task. Template mencakup:
- Latar belakang & tujuan
- Kondisi sebelum (BEFORE)
- Rencana (PLAN)
- Eksekusi (PROCESS)
- Snapshot & evidence
- Hasil akhir (AFTER)
- Dampak (IMPACT)
- Risiko (RISK)
- Rollback procedure
- Catatan tambahan

### Daily Summary Template

**File:** `reports-agents/_DAILY_SUMMARY_TEMPLATE.md`

Gunakan template ini untuk daily summary. Template mencakup:
- Overview hari ini
- Tasks completed
- System health summary
- Issues & incidents
- Alerts & notifications
- Deployments
- Security events
- Performance metrics
- Backup status
- Planned for tomorrow

### Tech Stack Template

**File:** `docs/tech-stack/_TEMPLATE.md`

Gunakan template ini untuk dokumentasi setiap komponen. Template mencakup:
- Overview komponen
- Configuration
- Deployment process
- Monitoring
- Backup & restore
- Common issues
- Performance tuning
- Security considerations
- Useful commands

---

## Maintenance

### Daily Tasks
- [ ] Check system health (CPU, memory, disk)
- [ ] Review alerts dan notifications
- [ ] Check backup status
- [ ] Review error logs
- [ ] Update task reports jika ada task

### Weekly Tasks
- [ ] Review weekly summary
- [ ] Update troubleshooting.md dengan issue baru
- [ ] Verify backups working
- [ ] Check disk space trends
- [ ] Review security logs

### Monthly Tasks
- [ ] Review changelog.md untuk pattern
- [ ] Update architecture docs jika ada perubahan besar
- [ ] Test disaster recovery procedure
- [ ] Review and update security measures
- [ ] Clean up old reports (> 6 months)

---

## Customization

### Server-Specific Customization

Template ini bisa disesuaikan dengan kebutuhan server:

**Tambah section baru:**
```bash
# Contoh: Tambah section untuk compliance
mkdir docs/compliance
nano docs/compliance/gdpr.md
nano docs/compliance/pci-dss.md
```

**Modifikasi template:**
```bash
# Edit template task report
nano reports-agents/_TASK_TEMPLATE.md
```

**Tambah automation:**
```bash
# Contoh: Auto-generate daily summary
nano /opt/docs/generate-daily-summary.sh
```

### Integration dengan Tools

**Prometheus + Grafana:**
- Link dashboard URLs di `docs/operations/monitoring.md`
- Document alert rules di `docs/operations/monitoring.md`

**ELK Stack:**
- Document Kibana URLs di `docs/operations/monitoring.md`
- Document log patterns di `docs/tech-stack/{app}.md`

**CI/CD Pipeline:**
- Document deployment triggers di `docs/operations/deployment.md`
- Document rollback procedures di `docs/operations/deployment.md`

---

## Troubleshooting Template Issues

### Issue: AI Agent tidak mengikuti rules

**Solution:**
- Pastikan `AGENTS.md` ada di root (`/root/AGENTS.md`)
- Check AI agent logs untuk melihat apakah rules dibaca
- Reinforce rules di setiap sesi

### Issue: Documentation tidak up-to-date

**Solution:**
- Setup reminder untuk review docs weekly
- Assign ownership untuk setiap section
- Use changelog.md untuk track updates

### Issue: Reports terlalu verbose

**Solution:**
- Focus pada key information di summary
- Use templates untuk konsistensi
- Archive old reports (> 6 months)

---

## Best Practices

### 1. Consistency is Key
- Gunakan format yang sama untuk semua reports
- Follow naming conventions (YYYY-MM-DD, snake_case)
- Update semua related docs saat ada perubahan

### 2. Evidence-Based Documentation
- Sertakan command output sebagai evidence
- Screenshot/dashboard untuk visual proof
- Log snippets untuk troubleshooting

### 3. Actionable Information
- Dokumentasi harus actionable (bisa langsung digunakan)
- Include exact commands, not just concepts
- Provide copy-paste ready solutions

### 4. Regular Reviews
- Review docs monthly untuk accuracy
- Update saat ada perubahan besar
- Archive outdated information

### 5. Collaborative Approach
- Multiple team members should contribute
- Peer review important changes
- Share knowledge through documentation

---

## Support & Resources

### Internal Resources
- **AGENTS.md:** Rules untuk AI agent
- **docs/README.md:** Index dokumentasi teknis
- **docs/troubleshooting.md:** Common issues & solutions
- **reports-agents/:** Audit log semua tasks

### External Resources
- **Server Monitoring:** {Grafana URL}
- **Log Management:** {Kibana URL}
- **Alerting:** {PagerDuty/Slack}
- **Backup Storage:** {S3/NFS location}

### Contacts
- **DevOps Lead:** {name} - {email}
- **Backend Lead:** {name} - {email}
- **System Admin:** {name} - {email}
- **Security Lead:** {name} - {email}

---

## Contributing to This Template

Jika Anda menemukan improvement untuk template ini:

1. **Identify the improvement** - Apa yang bisa diperbaiki?
2. **Test the change** - Pastikan tidak break existing workflow
3. **Document the change** - Update README ini
4. **Share with team** - Discuss di team meeting
5. **Implement** - Apply change jika disetujui

---

## License & Attribution

Template ini dibuat untuk internal use di {organization}. Boleh dimodifikasi dan disesuaikan dengan kebutuhan.

**Based on:** Production server documentation best practices
**Inspired by:** Real-world experience managing production servers with AI agents

---

**Template Version:** 1.0
**Last Updated:** 2026-06-09
**Maintained by:** DevOps Team
