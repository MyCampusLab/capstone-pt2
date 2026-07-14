# TECHNICAL_DEBT

> **Status:** DATA FILE — AI WAJIB mengupdate saat ada tech debt baru atau terselesaikan.
> **Purpose:** Catatan utang teknis yang diketahui. Untuk sadar risiko, bukan untuk langsung diperbaiki (kecuali diminta).

---

## IMMUTABLE -- AI TIDAK BOLEH MENGUBAH FILE INI. Baca template ini, lalu BUAT file BARU di folder output (dev-docs/, planning/, dll) -- JANGAN ubah template ini.

**What to CREATE in output folder:** Inventaris utang teknis. Jangan langsung memperbaiki tech debt tanpa permintaan user. Cukup catat agar agent berikutnya sadar.

###  Dual-Repo: Tanda Repo

Untuk fullstack, tiap debt entry Wajib mencantumkan repo (`backend` / `frontend`). Debt backend (query N+1) beda konteks dengan debt frontend (bundle size).

**When to update:**
- Saat menemukan area yang perlu refactor
- Saat menemukan code smell atau anti-pattern
- Saat ada workaround yang disengaja karena keterbatasan waktu
- Saat tech debt sudah dilunasi

**Priority definitions:**
- **P0:** Critical — bisa menyebabkan outage atau data loss
- **P1:** High — menghambat development atau performa
- **P2:** Medium — code smell, test gap
- **P3:** Low — cosmetic, nice to have

---

## Priority Debt List

| Priority | Repo | Debt | Evidence | Suggested Direction |
|----------|------|------|----------|-------------------|
| `{P0}` | `{backend/frontend/apps}` | `{deskripsi utang}` | `{bukti}` | `{saran perbaikan}` |

---

## Risky Areas to Modify

**Area yang berisiko tinggi jika dimodifikasi:**

| Area | Repo | Risk | Reason |
|------|------|------|--------|
| `{path/modul}` | `{backend/frontend}` | `{HIGH/MEDIUM}` | `{alasan}` |

---

## Debt Acceptance Notes

**Utang teknis yang disengaja dan diterima:**

- Assumption based on repository analysis: `{asumsi}`
- `{catatan_penerimaan_lain}`
