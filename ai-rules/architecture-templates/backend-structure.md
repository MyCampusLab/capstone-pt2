# Backend Structure

> **Status:** DATA FILE — AI WAJIB mengupdate saat ada perubahan struktur backend.
> **Purpose:** Dokumentasi struktur direktori backend, organisasi controller, service layer, middleware, dan command.

---

## IMMUTABLE -- AI TIDAK BOLEH MENGUBAH FILE INI. Baca template ini, lalu BUAT file BARU di folder output (dev-docs/, planning/, dll) -- JANGAN ubah template ini.

**What to CREATE in output folder:** Mapping direktori backend dan penjelasan peran setiap komponen. Ini adalah "peta harta karun" untuk navigasi kode backend.

**When to update:**
- Saat ada direktori baru
- Saat ada reorganisasi struktur
- Saat ada middleware/command baru yang signifikan

---

## Top-Level Backend Layout

| Path | Role |
|------|------|
| `{app/Http/Controllers}` | `{isi fungsi direktori}` |
| `{app/Http/Middleware}` | `{isi fungsi direktori}` |
| `{app/Models}` | `{isi fungsi direktori}` |
| `{app/Services}` | `{isi fungsi direktori}` |
| `{routes}` | `{isi fungsi direktori}` |
| `{config}` | `{isi fungsi direktori}` |
| `{database/migrations}` | `{isi fungsi direktori}` |

---

## Controller Organization

**Dokumentasikan bagaimana controller diorganisir:**
- Apakah per modul? Per domain?
- Apakah ada base controller?
- Apakah ada invocable controller?
- Apakah ada resource controller?

---

## Service Layer Usage

**Dokumentasikan service layer:**
- Apakah ada service layer atau logic di controller?
- Pola yang digunakan: Service class, Action class, Repository?
- Bagaimana dependency injection?

---

## Middleware and Security

| Middleware Alias | Purpose | Applied To |
|-----------------|---------|-----------|
| `{auth}` | `{tujuan}` | `{route/group}` |
| `{role:admin}` | `{tujuan}` | `{route/group}` |

---

## Command Architecture

**Dokumentasikan custom Artisan commands (atau CLI lain):**

| Command | Purpose | Schedule |
|---------|---------|----------|
| `{nama_command}` | `{tujuan}` | `{frekuensi}` |
