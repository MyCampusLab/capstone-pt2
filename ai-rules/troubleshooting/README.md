# Troubleshooting Guide for AI Agents

> **Status:** DATA FILE — AI WAJIB mencatat setiap masalah dan solusinya di sini.
> **Purpose:** Known gotchas, common errors, dan solusinya. Mencegah agent berikutnya mengulang debug yang sama.

---

## IMMUTABLE -- AI TIDAK BOLEH MENGUBAH FILE INI. Baca template ini, lalu BUAT file BARU di folder output (dev-docs/, planning/, dll) -- JANGAN ubah template ini.

**What to CREATE in output folder:** Setiap kali AI menemukan error yang tidak obvious dan menghabiskan waktu debugging, catat di sini.

###  CRITICAL: Anti-Monster Rule

**DILARANG** membuat satu file issue raksasa. Setelah satu issue ter-resolve dan stable selama >1 bulan, **pindahkan ke arsip**.

**Split strategy:**

| File | Isi |
|------|-----|
| `README.md` | Quick reference + issue yang masih OPEN |
| `resolved.md` | Issue yang sudah resolved — arsip permanen |

**Kapan pindah ke resolved.md:**
- Issue sudah di-fix dan fix-nya sudah terverifikasi berjalan stabil >1 bulan
- Issue yang sudah tidak relevan (environment berubah, dependency di-upgrade)

**Format:** Satu tabel quick reference di `README.md` (max 15 baris). Detail issue lengkap di file terpisah:

| File | Isi |
|------|-----|
| `issues/{YYYY-MM-DD}-{slug}.md` | Detail issue (jika perlu dokumentasi panjang) |

Untuk issue sederhana, tabel quick reference cukup.

---

## Quick Reference — Common Fixes

| Symptom | Quick Fix |
|---------|----------|
| `{error message singkat}` | `{solusi 1 baris}` |

---

## Open / Recent Issues

| # | Date | Symptom | Status | Link |
|---|------|---------|--------|------|
| 1 | `{YYYY-MM-DD}` | `{gejala}` | `{Open / Investigating / Fixed}` | `{issues/YYYY-MM-DD-slug.md jika ada}` |

---

## Environment-Specific Gotchas

| Gotcha | Env | Detail |
|--------|-----|--------|
| `{masalah}` | `{env mana}` | `{penjelasan}` |

---

## Debugging Tools & Commands

**Tools yang tersedia untuk debugging:**

| Tool | Command | Purpose |
|------|---------|---------|
| `{Debugbar / Telescope / Chrome DevTools / ...}` | `{command}` | `{purpose}` |

```bash
# Quick debug commands — gunakan command sesuai stack project
{ php artisan route:list | npm run routes | ... }
{ php artisan config:clear | ... }
{ php artisan cache:clear | ... }
{ php artisan queue:failed | ... }
```

---

## Archived Issues

Lihat [resolved.md](./resolved.md) untuk daftar issue yang sudah di-resolve.
