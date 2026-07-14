# Merger Plan — Gabung Aplikasi {B, C, ...} → {Aplikasi Utama}

> **Status:** PLANNING — HANYA untuk skenario merger/konsolidasi beberapa aplikasi terpisah menjadi 1.
> **Purpose:** Rencana penggabungan aplikasi B, C, ..., N ke dalam aplikasi A (utama). Setelah merger, hanya aplikasi A yang dipertahankan.

---

## IMMUTABLE -- AI TIDAK BOLEH MENGUBAH FILE INI. Baca template ini, lalu BUAT file BARU di folder output (dev-docs/, planning/, dll) -- JANGAN ubah template ini.

###  Kapan File Ini Dibuat

HANYA untuk skenario:
- Ada beberapa aplikasi terpisah yang akan digabung ke 1 aplikasi utama
- Aplikasi sumber (B, C, ..., N) akan di-drop setelah merger
- Aplikasi target (A) akan menyerap semua fitur dari B, C, ..., N sebagai modul

**Beda dengan revamp biasa:**
- Revamp: 1 old system → 1 new system (one-to-one)
- Merger: N old systems → 1 target system (many-to-one)

---

## 1. Application Inventory

| ID | Nama Aplikasi | URL | Repo | User Count | Status |
|----|-------------|-----|------|-----------|--------|
| A | `{aplikasi_utama}` | `{url}` | `{path}` | `{jumlah}` | **Target** (dipertahankan) |
| B | `{aplikasi_b}` | `{url}` | `{path}` | `{jumlah}` | Akan di-drop |
| C | `{aplikasi_c}` | `{url}` | `{path}` | `{jumlah}` | Akan di-drop |
| N | `{aplikasi_n}` | `{url}` | `{path}` | `{jumlah}` | Akan di-drop |

---

## 2. Per-App Audit Summary

### Aplikasi A (Target)

| Item | Detail |
|------|--------|
| Stack | `{framework}` |
| Arsitektur | `{monolith/fullstack}` |
| Jumlah modul existing | `{jumlah}` |
| Jumlah user | `{jumlah}` |
| DB size | `{ukuran}` |

**Modul existing:**
---
| Modul | Fungsi | Akan tetap? |
|-------|--------|-----------|
| `{modul_a1}` | `{fungsi}` | ✅ |
| `{modul_a2}` | `{fungsi}` | ✅ |

### Aplikasi B (Akan di-drop)

| Item | Detail |
|------|--------|
| Stack | `{framework}` |
| Arsitektur | `{monolith/fullstack}` |
| Jumlah modul | `{jumlah}` |
| DB size | `{ukuran}` |

**Modul yang dimigrasi:**
| Modul | Fungsi | Prioritas | User Impact |
|-------|--------|----------|-----------|
| `{modul_b1}` | `{fungsi}` | `{High}` | `{berapa user}` |
| `{modul_b2}` | `{fungsi}` | `{Low}` | `{berapa user}` |

### Aplikasi C (Akan di-drop)

| Item | Detail |
|------|--------|
| Stack | `{framework}` |
| DB size | `{ukuran}` |

**Modul yang dimigrasi:**
| Modul | Fungsi | Prioritas |
|-------|--------|----------|
| `{modul_c1}` | `{fungsi}` | `{High}` |

---

## 3. Overlap & Conflict Analysis

### Fitur yang Tumpang Tindih

| Fitur | Ada di Apps | Resolusi |
|-------|-----------|----------|
| `{user management}` | A, B, C | Pakai punya A, migrasi user B+C ke A |
| `{reporting}` | A, B | Merge kedua report engine ke modul A, atau pilih yang terbaik |
| `{dashboard}` | B, C | Konsolidasi ke 1 dashboard terpadu di A |

### Data yang Shared

| Data | Dipakai oleh | Strategi |
|------|-----------|----------|
| `{users}` | A, B, C | Single source: A. Migrasi user B+C via mapping |
| `{products}` | A, B | A punya product catalog utama, B punya product local → merge |

### Naming Conflict

| Nama | Conflict di | Resolusi |
|------|-----------|----------|
| Route `/admin/reports` | A dan B | B jadi `/admin/reports-b`, nanti diganti |
| Model `Transaction` | A dan B | B rename ke `TransactionB` selama transisi |

---

## 4. Merger Strategy

### Target Architecture (Setelah Merger)

```
Aplikasi A (Utama)
├── Modul A1 (existing)
├── Modul A2 (existing)
├── Modul B1 (migrasi dari B)   ← new
├── Modul B2 (migrasi dari B)   ← new
├── Modul C1 (migrasi dari C)   ← new
└── Modul ... (migrasi dari N)  ← new
```

### Phase Plan

| Phase | Aktivitas | Apps Terlibat |
|-------|----------|-------------|
| 0 | Audit semua aplikasi | A, B, C, ..., N |
| 1 | Standarisasi auth & user management di A | A |
| 2 | Merger modul prioritas tinggi dari B | B → A |
| 3 | Merger modul prioritas tinggi dari C | C → A |
| 4 | Merger sisa modul (B, C, ..., N) | Semua → A |
| 5 | Data migration final + decommission B, C, ..., N | Semua |

---

## 5. Data Merger Per Source

### Dari Aplikasi B → Aplikasi A

| Table B | Rows | Table A | Mapping Notes |
|---------|------|---------|-------------|
| `{users}` | `{100}` | `{users}` | Map user ID, hindari conflict |
| `{products_b}` | `{500}` | `{products}` | Tambah field `source: 'B'` |
| `{transactions_b}` | `{5000}` | `{transactions}` | Transform status values |

### Dari Aplikasi C → Aplikasi A

| Table C | Rows | Table A | Mapping Notes |
|---------|------|---------|-------------|
| `{users}` | `{50}` | `{users}` | |
| `{reports_c}` | `{200}` | `{reports}` | |

---

## 6. Decommission Plan

Setelah merger selesai dan terverifikasi:

| Aplikasi | Action | Timeline |
|----------|--------|----------|
| B | Read-only → redirect ke A → shutdown | `{tanggal}` |
| C | Read-only → redirect ke A → shutdown | `{tanggal}` |
| N | Read-only → redirect ke A → shutdown | `{tanggal}` |

**URL Redirect:** 
- `b.example.com` → `a.example.com/modul-b`
- `c.example.com` → `a.example.com/modul-c`

---

## 7. Risk Register

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|-----------|
| User ID conflict (duplicate across apps) | `{High}` | `{Critical}` | Pre-audit user, mapping table, merge script |
| Data loss saat migrasi | `{Med}` | `{Critical}` | Backup semua apps sebelum tiap migrasi |
| User bingung UI baru | `{High}` | `{Med}` | Training + redirect + masa transisi |
| Modul B bergantung ke modul A (circular) | `{Med}` | `{High}` | Analisis dependency per modul sebelum merge |
| Downtime berkepanjangan | `{Low}` | `{High}` | Rollback plan per aplikasi |
