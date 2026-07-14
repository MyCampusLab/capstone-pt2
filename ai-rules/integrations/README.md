# Third-Party Integrations Guide for AI Agents

> **Status:** DATA FILE — AI mengisi data integrasi spesifik project.
> **Purpose:** Daftar semua integrasi eksternal agar AI agent tahu dependency sistem dan tidak merusaknya.

---

## IMMUTABLE -- AI TIDAK BOLEH MENGUBAH FILE INI. Baca template ini, lalu BUAT file BARU di folder output (dev-docs/, planning/, dll) -- JANGAN ubah template ini.

**What to CREATE in output folder:** Semua integrasi dengan layanan eksternal — API, webhook, SDK, database eksternal.

###  CRITICAL: Anti-Monster Rule

**DILARANG** menumpuk semua detail integrasi dalam satu file ini. `README.md` hanya berisi **indeks + ringkasan 1 baris per integrasi**. Detail lengkap di file terpisah.

| File | Isi | Maks |
|------|-----|------|
| `README.md` | Indeks + ringkasan semua integrasi | Jangan tumpuk semua detail — cukup 1 baris per integrasi |
| `{service-slug}.md` | Detail satu integrasi: credential pattern, endpoints, fallback | Satu file per service |

**Aturan:**
- README.md = indeks, bukan ensiklopedia
- Setiap integrasi dapat file sendiri (`midtrans.md`, `sendgrid.md`, `aws-s3.md`)
- AI hanya membaca file integrasi yang relevan, bukan semua

**When to update:**
- Saat integrasi baru ditambahkan → tambah baris di indeks + buat file detail
- Saat integrasi dihapus → hapus baris + arsip/delete file detail
- Saat endpoint/credential pattern berubah → update file detail

---

## Integration Index

| # | Service | Type | Criticality | Detail |
|---|---------|------|------------|--------|
| 1 | `{nama_service}` | `{API / Webhook / SDK / DB Ext}` | `{HIGH / MED / LOW}` | `{service-slug}.md` |

---

## Integration Coding Rules

**Saat menambah atau memodifikasi integrasi, AI WAJIB:**
- [ ] Simpan credential di `.env` — jangan hardcode
- [ ] Tambahkan `.env` key ke `.env.example` (tanpa nilai real)
- [ ] Gunakan HTTP client yang sudah ada
- [ ] Handle failure dengan graceful degradation
- [ ] Log error ke file log yang sesuai
- [ ] Tulis test dengan mock/fake — jangan test ke live API
