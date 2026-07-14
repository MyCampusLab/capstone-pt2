# Old System Audit — {Nama Project Lama}

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** PLANNING — Analisis sistem yang sudah ada. Dokumentasikan SEBELUM menulis kode baru.
> **Purpose:** Pahami apa yang sudah berjalan — fitur, arsitektur, database, pain points. Ini acuan untuk `gap-analysis.md`.

---

## 1. System Identity

| Item | Detail |
|------|--------|
| Nama Sistem | `{nama}` |
| Tahun Dibangun | `{YYYY}` |
| URL Production | `{url}` |
| Repository | `{path atau url}` |
| Project Type | `{Monolith / Fullstack / lainnya}` |

---

## 2. Tech Stack (Old)

| Layer | Technology | Version |
|-------|-----------|---------|
| Backend | `{Laravel, CodeIgniter, dll}` | `{versi}` |
| Frontend | `{Blade, jQuery, Vue, dll}` | `{versi}` |
| Database | `{MySQL, PostgreSQL}` | `{versi}` |
| Web Server | `{Nginx, Apache}` | |
| PHP / Runtime | `{versi}` | |

---

## 3. Module / Feature Inventory

| # | Module | Status | User Count | Pain Level | Notes |
|---|--------|--------|-----------|-----------|-------|
| 1 | `{nama_modul}` | `{Active / Deprecated}` | `{estimasi}` | `{Low/Med/High}` | `{masalah}` |

**Pain Level:** Low = berfungsi baik, High = banyak keluhan / sering bug

---

## 4. Database Inventory

| Table | Rows (approx) | Size | Critical? | Notes |
|-------|-------------|------|----------|-------|
| `{users}` | `{jumlah}` | `{ukuran}` | ✅ | |
| `{tabel_lain}` | `{jumlah}` | `{ukuran}` | | |

**Total DB size:** `{ukuran}`

---

## 5. Architecture (Old)

### Pattern

`{MVC monolith, modular monolith, dll}`

### Directory Structure

```
apps/
├── app/
│   ├── Http/Controllers/
│   ├── Models/
│   └── ...
├── resources/views/
├── routes/
└── database/
```

### Key Dependencies

| Package | Version | Purpose | Masih Supported? |
|---------|---------|---------|----------------|
| `{package}` | `{versi}` | `{tujuan}` | ✅ / ❌ |

---

## 6. Pain Points & Reason for Revamp

| # | Pain Point | Impact | Priority |
|---|-----------|--------|----------|
| 1 | `{masalah}` | `{dampak}` | `{High/Med/Low}` |

**Kenapa revamp (bukan refactor):**
- `{alasan — contoh: "Laravel versi lama tidak didukung, sulit upgrade"}`
- `{alasan — contoh: "Ingin pisah BE dan FE untuk scalability"}`
- `{alasan — contoh: "Framework tidak cocok untuk use case baru"}`

---

## 7. Integration Points (Existing)

| Integration | Type | Critical? | Notes |
|-----------|------|----------|-------|
| `{payment gateway}` | API | ✅ | `{catatan}` |
| `{email service}` | SMTP | | `{catatan}` |

---

## 8. Users & Stakeholders

| Role | Jumlah | Kebutuhan Kritis |
|------|--------|----------------|
| `{role}` | `{estimasi}` | `{kebutuhan}` |
