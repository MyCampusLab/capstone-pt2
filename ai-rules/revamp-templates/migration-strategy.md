# Migration Strategy — Old → New System

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** PLANNING — Setelah gap analysis selesai. Ini adalah cetak biru transisi.
> **Purpose:** Bagaimana beralih dari old system ke new system dengan dampak minimal ke user.

---

## 1. Migration Approach

| Approach | Deskripsi | Dipilih? |
|----------|----------|---------|
| **Big Bang** | Switch sekaligus — old system mati, new system live | |
| **Phased** | Modul per modul dipindahkan bertahap | |
| **Parallel** | Kedua sistem jalan bareng, user dialihkan bertahap | |
| **Strangler Fig** | New system "membungkus" old system, fitur diganti satu per satu | |

**Approach terpilih:** `{pilihan}`

**Alasan:** `{kenapa approach ini}`

---

## 2. Phase Plan

### Phase 0: Preparation

| Task | Detail | Status |
|------|--------|--------|
| Audit old system | `old-system.md` | ✅ / ❌ |
| Gap analysis | `gap-analysis.md` | ✅ / ❌ |
| Setup new repo & CI/CD | `{backend/` + `frontend/` | ✅ / ❌ |
| API contract | `planning/api-contract.md` | ✅ / ❌ |
| Test environment | Staging server untuk new system | ✅ / ❌ |

### Phase 1: Foundation

| Task | Repo | Detail |
|------|------|--------|
| Auth system | `backend` | JWT-based, role & permission |
| Auth pages | `frontend` | Login, register, forgot password |
| Layout & navigation | `frontend` | Admin + public layout |
| CI/CD pipeline | `both` | GitHub Actions |

### Phase 2: Core Module Migration

| Old Module | New Module | Backend | Frontend | Data Migration |
|-----------|-----------|---------|----------|---------------|
| `{modul_a}` | `{modul_a}` | `{task}` | `{task}` | `{script}` |

### Phase 3: Remaining Modules

| Old Module | New Module | Backend | Frontend |
|-----------|-----------|---------|----------|
| `{modul_b}` | `{modul_b}` | `{task}` | `{task}` |

### Phase 4: Cutover

| Task | Detail |
|------|--------|
| Data migration final | Full sync dari old DB ke new DB |
| DNS switch | Arahkan domain ke new server |
| Old system freeze | Read-only mode atau shutdown |
| Monitoring | Pantau error rate 24 jam pertama |

---

## 3. Rollback Plan

**Jika new system gagal setelah cutover:**

| Step | Action | Time Estimate |
|------|--------|-------------|
| 1 | DNS switch back ke old server | 5 menit |
| 2 | Restart old system (jika perlu) | 2 menit |
| 3 | Verifikasi old system berjalan normal | 10 menit |
| 4 | Investigasi new system, perbaiki, jadwal ulang cutover | — |

**Rollback trigger:**
- Error rate >5%
- User tidak bisa login
- Data corruption terdeteksi

---

## 4. Timeline Summary

| Phase | Duration | Target |
|-------|----------|--------|
| Phase 0: Preparation | `{durasi}` | `{tanggal}` |
| Phase 1: Foundation | `{durasi}` | `{tanggal}` |
| Phase 2: Core Migration | `{durasi}` | `{tanggal}` |
| Phase 3: Remaining | `{durasi}` | `{tanggal}` |
| Phase 4: Cutover | `{durasi}` | `{tanggal}` |

---

## 5. Risk Register

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|-----------|
| Data loss saat migrasi | `{Med}` | `{Critical}` | Backup old DB sebelum tiap migrasi |
| User bingung UI baru | `{High}` | `{Med}` | Training + dokumentasi |
| Old system crash sebelum cutover | `{Low}` | `{High}` | Read-only mode, daily backup |
| API downtime saat cutover | `{Med}` | `{High}` | Cutover di jam sepi (weekend/malam) |
