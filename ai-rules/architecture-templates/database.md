# Database Architecture

> **Status:** DATA FILE — AI WAJIB mengupdate saat ada perubahan skema database.
> **Purpose:** Dokumentasi arsitektur database: koneksi, migrasi, relasi, storage.

---

## IMMUTABLE -- AI TIDAK BOLEH MENGUBAH FILE INI. Baca template ini, lalu BUAT file BARU di folder output (dev-docs/, planning/, dll) -- JANGAN ubah template ini.

**What to CREATE in output folder:** Peta database — koneksi, skema, migrasi, pola relasi, storage. AI harus bisa memahami struktur data hanya dari dokumen ini.

**When to update:**
- Saat ada database/koneksi baru
- Saat ada perubahan skema signifikan
- Saat ada migration baru yang fundamental
- Saat ada perubahan storage/policy

---

## Connection Map

| Connection | Driver | Host | Schema / Database | Notes |
|-----------|--------|------|-------------------|-------|
| `{default}` | `{mysql/pgsql}` | `{host}` | `{nama_db}` | `{catatan}` |
| `{nama_koneksi}` | `{mysql/pgsql/sqlite}` | `{host}` | `{nama_db}` | `{catatan}` |

---

## Migration Layout

| Path | Domain |
|------|--------|
| `{database/migrations}` | `{domain — core / modul_x / shared}` |

---

## Cross-Database Relationship Style

**Jelaskan bagaimana relasi antar database/skema ditangani:**
- Apakah ada cross-database query?
- Apakah data direplikasi?
- Apakah ada eventual consistency pattern?

---

## Storage Implications

**Dokumentasikan storage setup:**
- Di mana file upload disimpan?
- Apakah pakai local disk, S3, atau lainnya?
- Apakah ada symbolic link?
- Bagaimana akses file publik vs private?

---

## Operational Commands

> **Gunakan command sesuai stack project.** Contoh untuk Laravel — ganti dengan command yang sesuai.

| Domain | Command | Notes |
|--------|---------|-------|
| `{migrasi}` | `{php artisan migrate | npm run migrate | ...}` | `{catatan}` |
| `{seeder}` | `{php artisan db:seed | ...}` | `{catatan}` |
| `{backup}` | `{command}` | `{catatan}` |
