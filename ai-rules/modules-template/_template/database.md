# Database — {Nama Modul}

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** DATA FILE — Update saat migration, seeder, atau factory berubah.

---

## Migrations

| Migration | Table | Purpose |
|-----------|-------|---------|
| `{YYYY_MM_DD_create_nama_table}` | `{nama_tabel}` | Membuat tabel utama |
| `{YYYY_MM_DD_add_field_to_nama_table}` | `{nama_tabel}` | Menambah kolom |

---

## Table Schema

### `{nama_tabel}`

| Column | Type | Constraints | Notes |
|--------|------|------------|-------|
| `id` | bigint | PK, auto-increment | |
| `{field}` | `{type}` | `{nullable / unique / default}` | `{catatan}` |
| `created_at` | timestamp | | |
| `updated_at` | timestamp | | |
| `deleted_at` | timestamp | nullable | Soft delete (jika ada) |

---

## Seeders

| Seeder | Purpose | Data Source |
|--------|---------|------------|
| `{NamaSeeder}` | `{tujuan}` | `{hardcoded / CSV / factory}` |

---

## Factories

| Factory | Model | Key Fields |
|---------|-------|-----------|
| `{NamaFactory}` | `{NamaModel}` | `{field_yang_di-random}` |
