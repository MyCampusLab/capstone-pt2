# FINAL_SYSTEM_HANDOVER

> **Status:** DATA FILE — AI WAJIB mengupdate setelah push ke dev. Ini ringkasan kondisi akhir untuk engineer/AI berikutnya.
> **Note:** File ini **BOLEH di-include di `main`** sebagai referensi handover untuk deployment/production.
> **SECURITY:** File ini bisa masuk ke git repo (main branch). **DILARANG** mengandung credential, IP server, password, token, SSH key, connection string, atau secret apapun. Gunakan referensi ke `.env` atau `prod-docs/`.

---

## IMMUTABLE -- AI TIDAK BOLEH MENGUBAH FILE INI. Baca template ini, lalu BUAT file BARU di folder output (dev-docs/, planning/, dll) -- JANGAN ubah template ini.

**What to CREATE in output folder:** Ini adalah dokumen "handover" — ringkasan kondisi akhir aplikasi untuk engineer atau AI agent yang akan melanjutkan pekerjaan.

###  Dual-Repo: Handover Per Repo

- **Monolith** → isi 1 System Identity + 1 set module status
- **Fullstack** → 2 baris di System Identity (backend + frontend), module status per repo

**When to update:** Setiap selesai push ke `dev`, khususnya saat:
- Selesai satu milestone/fitur besar
- Akan handover ke engineer lain
- Akan deploy ke production

---

## System Identity

| Repo | Branch | Version | Last Commit |
|------|--------|---------|------------|
| `{apps — monolith} / {backend — fullstack} / {frontend — fullstack}` | `dev` | `{versi_terbaru}` | `{hash}` |

> **Version diambil dari:** `VERSION.md` — lihat section "Current Version".

| Project Type | `{Monolith / Fullstack}` |
| Last Updated | `{YYYY-MM-DD HH:mm}` |
| Handover Agent | `{model_AI_yang_terakhir_bekerja}` |

---

## Current Architecture Summary

**Jelaskan arsitektur sistem saat ini dalam 1-3 paragraf:**
- Pola arsitektur
- Komponen utama (backend, frontend, worker, dll)
- Dependency kritis (database, cache, queue, external API)
- **Fullstack:** jelaskan bagaimana BE dan FE berkomunikasi (API REST, GraphQL, WebSocket)

---

## Active Modules Status

| Module | Repo | State | Notes |
|--------|------|-------|-------|
| `{nama_modul}` | `{backend/frontend/apps}` | `{state}` | `{catatan — apa yang baru selesai, apa yang kurang}` |

---

## Recent Changes (Since Last Handover)

| Date | Repo | Type | Description | Impact |
|------|------|------|-------------|--------|
| `{YYYY-MM-DD}` | `{backend/frontend}` | `{feat/fix/refactor}` | `{deskripsi}` | `{dampak}` |

---

## Known Issues at Handover

| Area | Repo | Issue | Mitigation |
|------|------|-------|-----------|
| `{modul/komponen}` | `{backend/frontend}` | `{deskripsi}` | `{workaround / rencana}` |

---

## What Needs to Happen Next

**Prioritas pekerjaan berikutnya:**

| Priority | Repo | Task | Blockers |
|----------|------|------|----------|
| `{P0}` | `{backend/frontend}` | `{deskripsi}` | `{blocker}` |

---

## Deployment Notes

**Fullstack:** deployment bisa berbeda untuk backend dan frontend.

| Repo | DB Migration | Config Baru | Restart Service | Notes |
|------|-------------|------------|----------------|-------|
| `{backend}` | `{ada/tidak}` | `{ada/tidak}` | `{diperlukan/tidak}` | `{catatan}` |
| `{frontend}` | N/A | `{ada/tidak}` | `{diperlukan/tidak}` | `{catatan}` |

---

## Verification Commands

> **DILARANG** menggunakan IP server atau credential di command. Gunakan `localhost` untuk local commands, atau referensi ke `prod-docs/` untuk server commands.

```bash
# Backend (local)
{ cd backend && curl http://localhost:8000/health }
{ cd backend && php artisan about | npm run test | ... }

# Frontend (local)
{ cd frontend && curl http://localhost:3000 }
{ cd frontend && npm run build | ... }
```
