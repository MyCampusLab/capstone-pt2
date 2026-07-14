# Models — {Nama Modul}

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** DATA FILE — Update saat model baru dibuat atau relasi/scope berubah.

---

## Model Registry

| Model | Table | Connection | Location |
|-------|-------|-----------|----------|
| `{NamaModel}` | `{nama_tabel}` | `{default / koneksi_khusus}` | `{app/Models/...}` |

---

## Relationships

### {NamaModel}

| Relation | Type | Related Model | Foreign Key | Notes |
|----------|------|-------------|------------|-------|
| `{relasi}()` | `{hasMany / belongsTo / ...}` | `{RelatedModel}` | `{fk}` | `{catatan}` |

---

## Attributes

| Attribute | Cast | Fillable | Notes |
|----------|------|----------|-------|
| `{field}` | `{datetime / boolean / array}` | ✅ | `{catatan}` |

---

## Scopes

| Scope | Purpose |
|-------|---------|
| `scope{Name}()` | `{tujuan scope}` |

---

## Accessors / Mutators

| Method | Type | Purpose |
|--------|------|---------|
| `get{Nama}Attribute()` | Accessor | `{tujuan}` |
| `set{Nama}Attribute()` | Mutator | `{tujuan}` |
