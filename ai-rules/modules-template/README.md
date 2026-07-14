# Modules Documentation Index

> **Status:** GUIDANCE + DATA FILE — AI WAJIB mengikuti aturan split-per-concern. JANGAN buat satu file README monster.
> **Purpose:** Indeks semua modul aplikasi. Setiap modul punya folder sendiri dengan file dokumentasi terpisah per aspek.

---

## IMMUTABLE -- AI TIDAK BOLEH MENGUBAH FILE INI. Baca template ini, lalu BUAT file BARU di folder output (dev-docs/, planning/, dll) -- JANGAN ubah template ini.

###  CRITICAL: Split-Per-Concern Rule

**DILARANG** membuat satu file `README.md` raksasa per modul. AI akan kehabisan context window saat membaca file panjang untuk mencari info spesifik.

**WAJIB** — setiap modul di-split menjadi file-file kecil berdasarkan aspek:

| File | Isi | Kapan Dibuat |
|------|-----|-------------|
| `README.md` | **Indeks pendek** — overview modul + daftar file dengan link (jangan tumpuk semua isi di sini) | Selalu |
| `routes.md` | Route prefix, middleware, daftar endpoint | Jika modul punya route |
| `controllers.md` | Daftar controller, method, tanggung jawab masing-masing | Jika modul punya controller |
| `models.md` | Model, relationships, scopes, casts | Jika modul punya model |
| `services.md` | Service class, business logic, action classes | Jika ada service layer |
| `views.md` | View files, blade components, JS components | Jika ada frontend |
| `database.md` | Migrations, seeders, factories | Jika ada skema data |
| `dependencies.md` | Modul lain yang di-depend, external API yang dipakai | Jika ada dependency |

**Aturan:**
- File `README.md` per modul cukup **indeks + overview 1 paragraf** — jangan tumpuk semua isi modul di satu README, itu memberatkan context window AI
- Setiap file aspek **fokus pada 1 hal** — jangan campur routes + controllers + models
- Jika satu aspek masih terlalu besar, split lagi (contoh: `controllers-auth.md`, `controllers-report.md`)
- File yang tidak relevan **JANGAN dibuat** — modul kecil mungkin hanya butuh README + routes + controllers
- Gunakan format tabel untuk data terstruktur agar mudah di-scan
- **AI hanya membaca file yang relevan dengan task-nya** — tidak perlu membaca semua

### Module README Template

```markdown
# Module: {Nama Modul}

| Item | Value |
|------|-------|
| State | {Planned / In Progress / Beta / Production} |
| Route Prefix | `/{prefix}` |
| Middleware | `{auth}, {role:xxx}` |
| Dependencies | `{modul_lain}` |

## Purpose

{1-2 kalimat — apa fungsi modul ini}

## Quick Links

- Routes → [routes.md](./routes.md)
- Controllers → [controllers.md](./controllers.md)
- Models → [models.md](./models.md)
- Services → [services.md](./services.md)
- Views → [views.md](./views.md)
- Database → [database.md](./database.md)
- Dependencies → [dependencies.md](./dependencies.md)
```

### When to Update

- **`README.md`**: Saat state modul berubah atau ada aspek baru
- **File aspek lainnya**: Saat kode di aspek tersebut berubah

Lihat `_template/` untuk contoh lengkap struktur split.

---

## Module Index

| Module | State | Route | Quick Link |
|--------|-------|-------|------------|
| `{nama_modul}` | `{state}` | `/{prefix}` | `{nama_modul}/README.md` |

---

## Quick Navigation

- Gunakan `../ai/START_HERE.md` untuk urutan baca yang direkomendasikan
- Gunakan `../ai/MODULE_MAP.md` untuk mapping modul ke file kode aktual
- Lihat `_template/` untuk contoh struktur dokumentasi modul
