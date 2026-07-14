# Frontend Structure

> **Status:** DATA FILE — AI WAJIB mengupdate saat ada perubahan struktur frontend.
> **Purpose:** Dokumentasi struktur frontend: rendering, layout, komponen, dependency, asset pipeline.

---

## IMMUTABLE -- AI TIDAK BOLEH MENGUBAH FILE INI. Baca template ini, lalu BUAT file BARU di folder output (dev-docs/, planning/, dll) -- JANGAN ubah template ini.

**What to CREATE in output folder:** Peta frontend — bagaimana UI diorganisir, dirender, dan dibangun. AI harus bisa menemukan dan memodifikasi komponen UI dengan memahami struktur ini.

**When to update:**
- Saat ada perubahan rendering model (SSR/SPA/Hybrid)
- Saat ada perubahan struktur layout/komponen
- Saat ada dependency frontend baru
- Saat ada perubahan build pipeline

---

## Rendering Model

**Jelaskan bagaimana halaman dirender:**
- SSR (Server-Side Rendering)?
- SPA (Single Page Application)?
- Hybrid / Inertia.js / Livewire?
- Bagaimana data dikirim dari backend ke frontend?

---

## Layout Architecture

| Path | Purpose |
|------|---------|
| `{resources/views/layouts}` | `{tujuan — layout utama}` |
| `{resources/views/components}` | `{tujuan — komponen reusable}` |
| `{resources/views/modules}` | `{tujuan — view per modul}` |

---

## Page Organization

**Dokumentasikan bagaimana halaman diorganisir:**
- Apakah per modul? Per fitur?
- Apakah ada partial/slot pattern?
- Bagaimana navigasi/sidebar?

---

## Frontend Dependencies

| Dependency | Version | Use |
|-----------|---------|-----|
| `{Bootstrap}` | `{5.x}` | `{tujuan — CSS framework}` |
| `{DataTables}` | `{2.x}` | `{tujuan — server-side table}` |
| `{SweetAlert2}` | `{11.x}` | `{tujuan — alert/modal}` |
| `{Chart.js}` | `{4.x}` | `{tujuan — chart/graph}` |

---

## Asset Pipeline

**Dokumentasikan bagaimana asset dibuild:**
- Vite / Webpack / Laravel Mix?
- Di mana source file (CSS/JS)?
- Di mana output build?
- Bagaimana hot reload di development?
