# MODULE_MAP

> **Status:** DATA FILE — AI WAJIB mengupdate saat ada modul baru atau perubahan struktur modul.
> **Purpose:** Mapping visual antara modul bisnis dan komponen kode (routes, controllers, models, services, views).

---

## IMMUTABLE -- AI TIDAK BOLEH MENGUBAH FILE INI. Baca template ini, lalu BUAT file BARU di folder output (dev-docs/, planning/, dll) -- JANGAN ubah template ini.

**What to CREATE in output folder:** Peta hubungan antara modul bisnis dan file kode aktual.

###  CRITICAL: Dual-Repo Support

**Lihat deklarasi project type di `PROJECT_CONTEXT.md`.**

- **Monolith** (`apps/`) → isi 1 tabel Module to Code Map di bawah
- **Fullstack** (`backend/` + `frontend/`) → isi **2 sub-section**: `Backend Module Map` dan `Frontend Module Map`

Contoh fullstack: modul "Auth" bisa punya controller di backend (`backend/app/Controllers/Auth`) dan halaman login di frontend (`frontend/pages/login.vue`).

**When to update:**
- Saat modul baru dibuat
- Saat struktur file modul berubah
- Saat ada shared infrastructure baru

---

## Module to Code Map

### Monolith

> Isi section ini jika project monolith (`apps/`). Jika fullstack, hapus section ini dan isi Backend + Frontend di bawah.

| Module | Route File | Controllers | Models | Services | Views |
|--------|-----------|-------------|--------|----------|-------|
| `{nama_modul}` | `{path}` | `{path}` | `{path}` | `{path}` | `{path}` |

### Backend Map (Fullstack Only)

| Module | Route File | Controllers | Models | Services |
|--------|-----------|-------------|--------|----------|
| `{nama_modul}` | `{path}` | `{path}` | `{path}` | `{path}` |

### Frontend Map (Fullstack Only)

| Module | Pages | Components | API Client | Store |
|--------|-------|-----------|-----------|-------|
| `{nama_modul}` | `{path}` | `{path}` | `{path}` | `{path}` |

---

## Shared Infrastructure Map

| Area | Path | Repo | Notes |
|------|------|------|-------|
| `{Middleware}` | `{path}` | `{backend / apps}` | `{catatan}` |
| `{Auth/Guard}` | `{path}` | `{backend / apps}` | `{catatan}` |
| `{Helpers}` | `{path}` | `{backend / apps}` | `{catatan}` |
| `{Base Classes}` | `{path}` | `{backend / apps}` | `{catatan}` |
| `{Config}` | `{path}` | `{backend / apps}` | `{catatan}` |
