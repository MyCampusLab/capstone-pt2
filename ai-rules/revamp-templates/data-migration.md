# Data Migration Plan — Old → New Database

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** PLANNING — Setelah database gap analysis selesai.
> **Purpose:** Rencana detil migrasi data: mapping schema, script, verifikasi.

---

## 1. Database Connection Map

| Label | DB Engine | Host | Database | Role |
|-------|----------|------|----------|------|
| Old DB | `{MySQL}` | `{host}` | `{nama_db_lama}` | Source (read-only) |
| New DB | `{PostgreSQL}` | `{host}` | `{nama_db_baru}` | Target |

---

## 2. Table Migration Order

**Urutan penting** — tabel master dulu, baru tabel transaksi:

| # | Old Table | New Table | Rows (approx) | Strategy |
|---|----------|----------|-------------|----------|
| 1 | `{users}` | `{users}` | `{1000}` | Direct map |
| 2 | `{roles}` | `{roles}` | `{10}` | Direct map |
| 3 | `{categories}` | `{categories}` | `{50}` | Direct map |
| 4 | `{transactions}` | `{transactions}` | `{10000}` | Transform needed |

---

## 3. Field Mapping

### `{old_table}` → `{new_table}`

| Old Column | Old Type | New Column | New Type | Transform Rule |
|-----------|---------|-----------|---------|---------------|
| `id` | `int(11)` | `id` | `bigint` | Direct |
| `name` | `varchar(255)` | `name` | `text` | Direct |
| `status` | `tinyint` (0/1) | `status` | `varchar(20)` | Map: `0→inactive, 1→active` |
| `created_at` | `datetime` | `created_at` | `timestamptz` | Convert timezone |
| `password` | `md5 hash` | — | — | **SKIP** — re-hash with bcrypt via seeder |

---

## 4. Data Transform Rules

### Rule: Status Mapping
```text
Old: tinyint (0=inactive, 1=active, 2=suspended)
New: varchar (inactive, active, suspended)

Mapping:
0 → 'inactive'
1 → 'active'
2 → 'suspended'
```

### Rule: Password Migration
```text
Old: MD5 hash (tidak aman)
New: bcrypt

Strategi: Reset password untuk semua user.
- Generate random password → bcrypt → simpan di new DB
- Kirim email "reset password" ke semua user setelah cutover
```

### Rule: JSON Field Migration
```text
Old: TEXT field berisi JSON string (unstructured)
New: JSONB column

Transform: parse JSON string → validasi → simpan sebagai JSONB
```

---

## 5. Migration Scripts

### Script 1: `migrate_users.sh`
```bash
#!/bin/bash
# Migrasi table users dari old DB ke new DB

# Export dari old DB
mysql -h {old_host} -u {user} -p {old_db} \
  -e "SELECT id, name, email, status, created_at FROM users" \
  | sed 's/\t/,/g' > /tmp/users_export.csv

# Transform & import ke new DB (contoh pakai psql \copy)
psql -h {new_host} -U {user} -d {new_db} \
  -c "\COPY users(id, name, email, status, created_at) FROM '/tmp/users_export.csv' CSV HEADER"
```

### Script 2: `migrate_transactions.sh`
```bash
# Export, transform status field, import
...
```

---

## 6. Verification Checklist

Setelah tiap migrasi tabel, verifikasi:

| # | Check | Query | Expected |
|---|-------|-------|----------|
| 1 | Row count match | `SELECT count(*) FROM {table}` | Sama dengan old |
| 2 | No null in required fields | `SELECT count(*) FROM {table} WHERE {field} IS NULL` | 0 |
| 3 | Status values valid | `SELECT DISTINCT status FROM {table}` | Hanya: 'active','inactive','suspended' |
| 4 | Foreign keys intact | `{query join check}` | Tidak ada orphan |

---

## 7. Rollback Plan

Jika data migration gagal di tengah jalan:

```bash
# Truncate tabel yang sudah ter-migrasi di new DB
psql -h {new_host} -U {user} -d {new_db} -c "TRUNCATE {table1}, {table2} RESTART IDENTITY CASCADE"

# Jalankan ulang script migrasi dari awal
bash migrate_users.sh
bash migrate_transactions.sh
```
