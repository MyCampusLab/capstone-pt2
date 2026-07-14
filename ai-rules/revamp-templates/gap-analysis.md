# Gap Analysis — Old vs New System

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** PLANNING — Setelah audit old system selesai. Dokumentasikan perbedaan sebelum mulai coding.
> **Purpose:** Identifikasi apa yang berubah, apa yang tetap, apa yang baru. Acuan untuk `migration-strategy.md`.

---

## 1. Stack Comparison

| Layer | Old | New | Reason for Change |
|-------|-----|-----|------------------|
| Backend | `{old_framework}` | `{new_framework}` | `{alasan}` |
| Frontend | `{old_ui}` | `{new_ui}` | `{alasan}` |
| Database | `{old_db}` | `{new_db}` | `{alasan — atau "tetap"}` |
| Auth | `{old_auth}` | `{new_auth}` | `{alasan}` |

---

## 2. Feature Gap

| Module | Old System | New System | Action |
|--------|-----------|-----------|--------|
| `{modul_a}` | ✅ Ada | ✅ Dipertahankan | Migrasi |
| `{modul_b}` | ✅ Ada | ❌ Dihapus | Drop — alasan: `{kenapa}` |
| `{modul_c}` | ❌ Tidak ada | ✅ Baru | Build new |
| `{modul_d}` | ✅ Ada (basic) | ✅ Enhanced | Improve — `{apa yang di-improve}` |

---

## 3. Database Gap

| Table | Old Schema | New Schema | Migration Strategy |
|-------|-----------|-----------|------------------|
| `{users}` | `{struktur lama}` | `{struktur baru}` | Mapping: `{field_lama}` → `{field_baru}` |
| `{tabel_lain}` | — | — | — |

**Data yang DROP (tidak dimigrasi):**
- `{tabel}` — alasan: `{kenapa}`

**Data yang perlu TRANSFORM:**
- `{tabel.field}` — dari format `{lama}` ke `{baru}` via `{script/logic}`

---

## 4. API / Endpoint Gap

| Old Endpoint (monolith route) | New Endpoint (REST API) | Notes |
|------------------------------|------------------------|-------|
| `GET /admin/users` | `GET /api/v1/users` | |
| `POST /admin/users` | `POST /api/v1/users` | |

---

## 5. Business Logic Gap

| Logic | Old Implementation | New Implementation | Notes |
|-------|------------------|-------------------|-------|
| `{auth}` | `{session-based}` | `{JWT-based}` | Perlu logout massal? |
| `{pagination}` | `{laravel paginate}` | `{custom pagination}` | |

---

## 6. Infrastructure Gap

| Component | Old | New | Notes |
|-----------|-----|-----|-------|
| Hosting | `{shared hosting}` | `{VPS / cloud}` | |
| CI/CD | `{tidak ada}` | `{GitHub Actions}` | |
| Monitoring | `{tidak ada}` | `{Sentry / Grafana}` | |
| Backup | `{manual}` | `{automated cron}` | |
