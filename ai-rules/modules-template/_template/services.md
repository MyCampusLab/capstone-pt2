# Services — {Nama Modul}

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** DATA FILE — Update saat service class atau business logic berubah.

---

## Service Registry

| Service | Location | Purpose |
|---------|----------|---------|
| `{NamaService}` | `{app/Services/...}` | `{tanggung jawab}` |

---

## Method Details

### {NamaService}

**Path:** `{app/Services/Modules/NamaModul/NamaService.php}`

| Method | Purpose | Side Effects |
|--------|---------|-------------|
| `{method}()` | `{deskripsi}` | `{event dispatch / queue job / log / email}` |

---

## Business Rules

**Aturan bisnis yang di-enforce di service layer:**

- `{aturan_1}`
- `{aturan_2}`

---

## Transactions

**Method yang menggunakan DB transaction:**

| Method | Transaction Scope | Rollback On |
|--------|-----------------|------------|
| `{method}()` | `{seluruh method / partial}` | `{exception type}` |
