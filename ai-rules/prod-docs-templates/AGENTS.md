# AGENTS.md — Aturan untuk AI Agent di Server Production

> **IMMUTABLE — AI TIDAK BOLEH mengubah file ini. Ini adalah TEMPLATE. AI membuat output di prod-docs/ dari template ini.**

> **Status:** GUIDANCE FILE — Do NOT replace. File ini adalah kontrak kerja AI agent di server production.
> **Purpose:** Entry point utama yang dibaca oleh AI agent saat sesi dimulai di server production.
> **Output Location:** `prod-docs/` — **DI LUAR git repo, di-copy ke server production. Credential dan IP BOLEH di dokumentasi ini karena tidak di-push ke GitHub. Tapi DILARANG di file .md di dalam folder kode (apps/, backend/, frontend/).**

---

## Server Information

| Item | Value |
|------|-------|
| Server Name | `{server_name}` |
| Hostname | `{hostname}` |
| IP Address | `{ip_address}` |
| Domain | `{domain}` |
| OS | `{os_version}` |
| Environment | Production |

---

##  PRE-DEPLOYMENT: Informasi dari Development

**WAJIB dibaca SEBELUM setup server atau deployment pertama kali.**

### Skenario 1: AI Agent yang Sama (Development + Deployment)

Jika kamu adalah AI agent yang juga mengerjakan development project ini:

1. **Baca dev-docs/ dari project repository:**
   - `dev-docs/ai/PROJECT_CONTEXT.md` — Tech stack dan arsitektur aplikasi
   - `dev-docs/architecture/` — Diagram arsitektur, API flow, database schema
   - `ai-rules/deployment/production-readiness.md` — **BRIDGE DOCUMENT** (checklist lengkap)
   - `ai-rules/operations/` — Setup supervisor, cronjob, backup scripts
   - `ai-rules/security/README.md` — Security requirements dan hardening

2. **Extract informasi untuk mengisi prod-docs/:**
   - Tech stack versions → `~/docs/tech-stack/`
   - Architecture diagram → `~/docs/architecture/overview.md`
   - Deployment process → `~/docs/operations/deployment.md`
   - Security requirements → `~/docs/operations/security.md`

3. **Verifikasi production-readiness.md:**
    - Jalankan semua checklist di `ai-rules/deployment/production-readiness.md`
   - Dokumentasikan hasil setiap step di `~/reports-agents/`

### Skenario 2: AI Agent Berbeda (Hanya Deployment/Operations)

Jika kamu AI agent yang hanya handle server production (tidak terlibat development):

1. **Minta dokumen berikut dari development team:**
   - `production-readiness.md` — Checklist lengkap requirements
   - `.env.example` — Template environment variables
   - `docker-compose.yml` — Container configuration
   - Application repository access

2. **Baca production-readiness.md:**
   - Pahami system requirements (CPU, RAM, disk)
   - Pahami software requirements (versions yang harus diinstall)
   - Pahami architecture (komponen apa saja yang harus di-setup)
   - Pahami security requirements (hardening yang harus dilakukan)

3. **Setup server sesuai checklist:**
   - Ikuti step-by-step di production-readiness.md
   - Dokumentasikan setiap step di `~/reports-agents/`
   - Update `~/docs/` dengan informasi aktual server

### Informasi Kunci yang Harus Didapat

| Kategori | Sumber (dev-docs) | Target (prod-docs) |
|----------|-------------------|-------------------|
| Tech stack versions | `ai/PROJECT_CONTEXT.md` | `docs/tech-stack/*.md` |
| Architecture | `architecture/` | `docs/architecture/overview.md` |
| Database schema | `architecture/database.md` | `docs/tech-stack/database.md` |
| Deployment process | `deployment/` | `docs/operations/deployment.md` |
| Operations setup | `operations/` | `docs/operations/*.md` |
| Security requirements | `security/README.md` | `docs/operations/security.md` |
| Environment variables | `.env.example` (repo) | `docs/operations/deployment.md` |

### Checklist Pre-Deployment

**Sebelum mulai setup server, pastikan:**

- [ ] Sudah baca `production-readiness.md` (jika ada)
- [ ] Sudah paham tech stack yang harus diinstall
- [ ] Sudah paham arsitektur aplikasi
- [ ] Sudah punya akses ke application repository — **clone URL + credential (SSH key atau token)**
- [ ] Sudah setup git di server — lihat [repository-access.md](../docs/operations/repository-access.md)
- [ ] Sudah punya `.env.example` untuk referensi
- [ ] Sudah tahu domain yang akan digunakan
- [ ] Sudah tahu SSL certificate strategy
- [ ] Sudah tahu backup strategy

**Jika ada informasi yang kurang, TANYA ke user sebelum lanjut.**

---

##  CRITICAL: Production Environment Rules

### 1. READ-FIRST Protocol (WAJIB Setiap Sesi Baru)

Sebelum menjalankan task APAPUN, WAJIB baca:

1. **`~/docs/README.md`** — Index dokumentasi teknis (arsitektur, tech stack, operasional)
2. **`~/reports-agents/changelog.md`** — Audit log semua task sebelumnya
3. **File terkait di `~/docs/tech-stack/`** — Untuk komponen yang akan diubah

**JANGAN** langsung eksekusi command tanpa memahami konteks sistem.

### 2. SAFETY First (Non-Negotiable)

- **JANGAN** jalankan destructive commands tanpa konfirmasi user
- **JANGAN** modify production database tanpa backup terlebih dahulu
- **JANGAN** restart critical services (nginx, database) tanpa approval
- **SELALU** test command di staging/dev jika memungkinkan
- **SELALU** dokumentasikan rollback procedure sebelum eksekusi
- **SELALU** cek disk space, memory, dan CPU sebelum operasi berat

### 3. Documentation is MANDATORY (Non-Negotiable)

Setiap task WAJIB menghasilkan:
- Laporan task di `~/reports-agents/YYYY-MM-DD/<task-name>.md`
- Update `~/reports-agents/changelog.md` (audit log entry)
- Update `~/docs/changelog.md` jika ada perubahan teknologi/arsitektur
- Update **SEMUA** file `~/docs/` yang terdampak (lihat checklist di bawah)

**Jika tidak ada perubahan dokumentasi, tulis alasan eksplisit di output akhir.**

---

## OUTPUT WAJIB (SETIAP TASK)

### Format Laporan Task

Setiap task menghasilkan laporan di `~/reports-agents/YYYY-MM-DD/<task-name>.md`.

Laporan harus **deskriptif dan teknis** — pembaca harus memahami apa yang terjadi, mengapa, dan apa dampaknya. Bukan hanya command dump.

```markdown
# <Judul Task>

> Tanggal: YYYY-MM-DD
> Eksekutor: AI Agent (CommandCode) / <nama teknisi>
> Status: SUCCESS / FAILED / PARTIAL

---

## Latar Belakang & Tujuan
MENGAPA task ini dilakukan? Apa masalahnya? Apa yang ingin dicapai?

## Kondisi Sebelum (BEFORE)
Kondisi awal sistem SEBELUM perubahan. Service, config, masalah yang ada.

## Rencana (PLAN)
APA yang akan dilakukan, MENGAPA pendekatan ini dipilih, risiko yang diantisipasi.

## Eksekusi (PROCESS)
Langkah teknis berurutan. WAJIB sertakan:
- Command dalam code block
- Output penting (bukan semua output, hanya yang relevan)
- Config sebelum → sesudah
- Error dan cara mengatasinya

## Snapshot & Evidence
WAJIB sertakan bukti teknis:
- Output `docker ps`, `systemctl status`, `ss -tlnp`
- Output `curl -I` untuk verifikasi endpoint
- Log snippets yang relevan
- Resource usage (`docker stats`, `free -h`, `df -h`)

## Hasil Akhir (AFTER)
Kondisi sistem SETELAH perubahan. Service status, endpoint status, config aktif.

## Dampak (IMPACT)
Dampak terhadap pengguna, service lain, performa, keamanan.

## Risiko (RISK)
Potensi masalah yang mungkin muncul.

## Rollback (ROLLBACK)
Cara kembali ke kondisi awal dengan command.

## Catatan Tambahan
Insight, temuan tak terduga, rekomendasi untuk task selanjutnya.
```

---

## REPORT HARIAN

Setiap hari ada task, WAJIB:

1. Buat folder: `~/reports-agents/YYYY-MM-DD/`
2. Setiap task punya file laporan di folder tersebut
3. Buat `~/reports-agents/YYYY-MM-DD/00-summary.md` berisi:
   - Daftar task hari ini + status
   - Perubahan signifikan
   - Issue yang belum selesai

---

## UPDATE DOKUMEN CHECKLIST

Saat ada perubahan sistem, WAJIB update **SEMUA file yang relevan** di `~/docs/`:

| Perubahan | File yang diupdate |
|-----------|-------------------|
| Arsitektur (service baru/hapus, topology) | `~/docs/architecture/overview.md`, `network-topology.md`, `~/docs/changelog.md` |
| Tech stack (upgrade, ganti versi) | `~/docs/tech-stack/<komponen>.md`, `~/docs/changelog.md` |
| Konfigurasi (rate limit, resource, port) | File terkait di `~/docs/`, `~/docs/changelog.md` |
| Security (hardening, secrets) | `~/docs/operations/security.md`, `~/docs/changelog.md` |
| Deploy process | `~/docs/operations/deployment.md`, `~/docs/changelog.md` |
| Backup procedure | `~/docs/operations/backup.md`, `~/docs/changelog.md` |
| Monitoring | `~/docs/operations/monitoring.md`, `~/docs/changelog.md` |
| Troubleshooting (issue baru ditemukan) | `~/docs/troubleshooting.md` |

---

## CARA KERJA AI AGENT

### 1. Analyze Before Act

```bash
# SELALU cek kondisi sistem sebelum eksekusi
df -h                    # Disk space
free -h                  # Memory
docker ps                # Container status
systemctl list-units     # Service status
ss -tlnp                 # Port usage
```

### 2. Document Before Change

```bash
# Backup config sebelum modify
cp /path/to/config /path/to/config.backup.$(date +%Y%m%d_%H%M%S)

# Screenshot/snapshot kondisi before
docker ps > /tmp/docker-before.txt
systemctl status nginx > /tmp/nginx-before.txt
```

### 3. Test After Change

```bash
# Verifikasi setelah perubahan
docker ps                # Container masih running?
systemctl status nginx   # Service active?
curl -I https://domain   # Endpoint accessible?
tail -f /var/log/nginx/error.log  # Ada error?
```

### 4. Update Documentation

Setelah task selesai:
1. Tulis laporan task
2. Update changelog
3. Update docs yang terdampak
4. Verifikasi semua dokumentasi akurat

---

## COMMANDS YANG BERBAHAYA (JANGAN JALANKAN TANPA APPROVAL)

| Command | Risiko | Alternatif |
|---------|--------|-----------|
| `rm -rf` | Data loss permanent | Gunakan `trash` atau backup dulu |
| `docker system prune -a` | Hapus semua unused images | Gunakan `docker image prune` saja |
| `DROP TABLE/DATABASE` | Data loss | Selalu backup dulu |
| `systemctl stop nginx` | Service down | Test di staging dulu |
| `chmod 777` | Security risk | Gunakan permission yang tepat |
| `iptables -F` | Firewall disabled | Backup rules dulu |

---

## EMERGENCY PROCEDURES

### Jika Service Down

1. **Check logs**: `docker logs <container>` atau `journalctl -u <service>`
2. **Check resources**: `docker stats`, `free -h`, `df -h`
3. **Restart service**: `systemctl restart <service>` atau `docker compose restart`
4. **Verify**: `curl -I https://domain`, check logs again
5. **Document**: Tulis incident report di `~/reports-agents/YYYY-MM-DD/`

### Jika Disk Full

1. **Check usage**: `df -h`, `du -sh /* | sort -hr | head -20`
2. **Clean logs**: `journalctl --vacuum-time=7d`
3. **Clean Docker**: `docker system prune` (hati-hati!)
4. **Check backups**: Hapus backup lama jika perlu
5. **Document**: Tulis di troubleshooting.md

### Jika Security Breach

1. **ISOLATE**: Stop affected service immediately
2. **ASSESS**: Check logs, identify scope
3. **CONTAIN**: Block suspicious IPs, revoke credentials
4. **FIX**: Patch vulnerability, restore from backup
5. **DOCUMENT**: Full incident report + post-mortem

---

## BEST PRACTICES

### 1. Always Use Screens/Tmux

```bash
# Untuk long-running tasks
tmux new -s deployment
# Atau
screen -S backup
```

### 2. Always Backup Before Modify

```bash
# Config files
cp config.yml config.yml.backup.$(date +%Y%m%d_%H%M%S)

# Database
mysqldump -u user -p database > backup_$(date +%Y%m%d_%H%M%S).sql

# Docker volumes
docker run --rm -v volume:/data -v $(pwd):/backup alpine tar czf /backup/volume_$(date +%Y%m%d_%H%M%S).tar.gz /data
```

### 3. Always Test in Isolation

```bash
# Test command di container temporary
docker run --rm -it alpine sh

# Test nginx config sebelum reload
nginx -t

# Test docker compose sebelum up
docker compose config
```

### 4. Always Monitor After Change

```bash
# Watch logs real-time
docker logs -f <container>
tail -f /var/log/nginx/access.log

# Monitor resources
watch -n 1 'docker stats --no-stream'
htop
```

---

## FILE LOCATIONS

| Item | Location |
|------|----------|
| Server documentation | `~/docs/` |
| Task reports | `~/reports-agents/` |
| Application code | `/opt/<app-name>/` |
| Docker compose files | `/opt/<app-name>/docker-compose.yml` |
| Nginx config | `/etc/nginx/sites-available/` |
| Systemd services | `/etc/systemd/system/` |
| Backups | `~/backups/` atau `/opt/backups/` |
| Logs | `/var/log/` atau `/opt/<app-name>/logs/` |

---

## CONTACT & ESCALATION

| Role | Contact | When to Escalate |
|------|---------|------------------|
| DevOps Lead | `{contact}` | Infrastructure issues, security incidents |
| Backend Lead | `{contact}` | Application bugs, database issues |
| Frontend Lead | `{contact}` | UI issues, frontend bugs |
| System Admin | `{contact}` | OS-level issues, network problems |

---

**Last Updated:** {YYYY-MM-DD}
**Maintained by:** AI Agent + DevOps Team
