# Postman Artifacts

> **Status:** OPTIONAL — HANYA dibuat jika user meminta atau ada developer eksternal (mobile/frontend) yang butuh dokumentasi API.
> **Purpose:** Folder untuk Postman collection + environment + developer guide. Digunakan oleh developer eksternal yang tidak punya akses ke kode backend.

---

## IMMUTABLE -- AI TIDAK BOLEH MENGUBAH FILE INI. Baca template ini, lalu BUAT file BARU di folder output (dev-docs/, planning/, dll) -- JANGAN ubah template ini.

###  Kapan Folder Ini Dibuat

Folder `dev-docs/postman/` HANYA dibuat jika:
1. **User meminta secara eksplisit:** "buatkan postman collection untuk API ini"
2. **Ada developer eksternal** yang akan consume API (mobile app developer, frontend developer di repo berbeda, third-party integrator)

**JANGAN dibuat otomatis.** Jika project fullstack dengan 1 AI yang mengerjakan BE dan FE, Postman tidak diperlukan — AI langsung consume API dari kode.

**JANGAN dibuat di monolith** kecuali user meminta — Blade view langsung akses controller, tidak perlu postman.

### Isi Folder

| File | Purpose | Wajib? |
|------|---------|--------|
| `README.md` | Panduan setup Postman + aturan sinkronisasi | ✅ |
| `{project}-API.postman_collection.json` | Collection semua endpoint | ✅ |
| `{project}-API.local.postman_environment.json` | Environment variables (base_url, token, credentials) | ✅ |
| `DEVELOPER_GUIDE.md` | Panduan lengkap untuk developer eksternal (auth flow, endpoint groups, catatan integrasi, security notes) | ✅ |
| `api-flow-overview.md` | Diagram alur API per modul | Opsional |

### Aturan Sinkronisasi

Setiap ada perubahan endpoint (backend), AI wajib sinkronkan:

1. Update endpoint di kode backend
2. Update `{project}-API.postman_collection.json` — tambah/ubah/remove request
3. Update `{project}-API.local.postman_environment.json` — jika variabel berubah
4. Update `DEVELOPER_GUIDE.md` — jika kontrak API berubah
5. Import ulang ke Postman lokal (jika user minta): `newman run collection.json -e environment.json`

### Template

Lihat `_template/` untuk template collection, environment, dan developer guide.
