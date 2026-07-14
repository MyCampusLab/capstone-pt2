# Deployment Guide for AI Agents

> **Status:** GUIDANCE + DATA FILE — AI mengisi data deployment spesifik project, tapi TIDAK mengubah instruksi di bawah "---" divider.
> **Purpose:** Panduan deployment agar AI agent paham environment, build steps, dan prosedur release.
> **Related:**
> - Git remote & repo credentials → [git-remote.md](./git-remote.md) (WAJIB — auto-detection dari local project atau manual input)
> - SSH access rules → [ssh-access.md](./ssh-access.md) (hanya jika project punya server)
> - Production readiness checklist → [production-readiness.md](./production-readiness.md)
> - Maintenance KAK & laporan templates → [maintenance/](./maintenance/) (hanya jika MAINTENANCE_ACTIVE: true)

---

## IMMUTABLE -- AI TIDAK BOLEH MENGUBAH FILE INI. Baca template ini, lalu BUAT file BARU di folder output (dev-docs/, planning/, dll) -- JANGAN ubah template ini.

**What to CREATE in output folder:** Semua informasi tentang bagaimana aplikasi ini di-deploy. AI harus tahu ini sebelum menyarankan atau melakukan deployment.

###  Dual-Repo: Deploy Per Repo

Untuk fullstack, backend dan frontend mungkin deploy terpisah (beda server, beda pipeline). Isi environment matrix dan build steps untuk masing-masing.

**When to update:**
- Saat environment baru ditambahkan
- Saat build/deploy command berubah
- Saat infrastruktur bermigrasi
- Saat CI/CD pipeline berubah

---

## Environment Matrix

| Environment | Backend URL | Frontend URL | Branch | Purpose |
|------------|------------|-------------|--------|---------|
| `{local}` | `{http://localhost:8000}` | `{http://localhost:3000}` | `{dev/feat/*}` | Development |
| `{staging}` | `{https://api-staging.example.com}` | `{https://staging.example.com}` | `{dev}` | Testing |
| `{production}` | `{https://api.example.com}` | `{https://example.com}` | `{main}` | Live |

---

## Infrastructure

| Component | Technology | Notes |
|-----------|-----------|-------|
| Web Server | `{Nginx / Apache / Caddy}` | `{catatan}` |
| Backend Runtime | `{PHP-FPM / Node / Go}` | `{versi}` |
| Database | `{MySQL / PostgreSQL / SQLite}` | `{versi + host}` |
| Cache | `{Redis / Memcached}` | `{host + port}` |
| Queue Worker | `{Horizon / Supervisor / Systemd}` | `{catatan}` |
| Storage | `{Local / S3 / DO Spaces}` | `{catatan}` |
| CDN | `{Cloudflare / lainnya}` | `{catatan}` |
| SSL | `{Let's Encrypt / Cloudflare / manual}` | `{catatan}` |

---

## Build Steps

> **Gunakan command sesuai stack project.**

### Local Dev
```bash
# Backend
{ composer install | npm install | go mod download }
{ npm run dev | go run . }
{ php artisan migrate | npm run migrate | ... }

# Frontend (fullstack only)
{ cd frontend && npm install }
{ npm run dev }
```

### Production Build
```bash
# Backend
{ composer install --no-dev --optimize-autoloader | npm ci | ... }
{ php artisan migrate --force | npm run migrate | ... }

# Frontend (fullstack only)
{ npm run build | next build | nuxt build | ... }
```

---

## CI/CD Pipeline

| Stage | Repo | What Happens |
|-------|------|-------------|
| `{lint}` | `{backend}` | `{phpstan / eslint / pint}` |
| `{test}` | `{backend}` | `{PHPUnit / Jest}` |
| `{lint}` | `{frontend}` | `{eslint / prettier}` |
| `{build}` | `{frontend}` | `{npm run build}` |

---

## Pre-Deploy Checklist

Sebelum deploy ke production, AI WAJIB verifikasi:
- [ ] All tests pass di branch `dev`
- [ ] Lint pass (backend + frontend)
- [ ] Build sukses (frontend)
- [ ] Tidak ada migration breaking change
- [ ] `.env` production sudah berisi semua key baru (dicek manual oleh human)
- [ ] Rollback plan siap jika deployment gagal

---

## Post-Deploy Verification

Setelah deploy:
```bash
# Backend smoke test
{ curl https://api.example.com/health }
{ php artisan about | npm run test | ... }

# Frontend smoke test
{ curl https://example.com }
```

---

## Rollback Procedure

Jika deployment gagal:

```bash
# Backend rollback
cd backend
git checkout main
git revert <MERGE_COMMIT_HASH>
git push
{ php artisan migrate:rollback --step={N} | ... }

# Frontend rollback
cd frontend
git checkout main
git revert <MERGE_COMMIT_HASH>
git push
```
