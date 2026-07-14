# Views — {Nama Modul}

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** DATA FILE — Update saat view file atau komponen frontend berubah.

---

## View File Registry

| File | Purpose | Dependencies |
|------|---------|-------------|
| `{index.blade.php}` | Daftar data | DataTables, SweetAlert |
| `{create.blade.php}` | Form create | `{form_components}` |
| `{edit.blade.php}` | Form edit | `{form_components}` |
| `{show.blade.php}` | Detail | — |

---

## Blade Components Used

| Component | Purpose |
|-----------|---------|
| `{x-modal}` | Modal konfirmasi |
| `{x-input}` | Form input reusable |
| `{x-select}` | Dropdown reusable |

---

## JavaScript / Alpine

| File / Inline | Purpose |
|-------------|---------|
| `{resources/js/modules/...}` | `{tujuan}` |
| Inline `@push('scripts')` | `{tujuan}` |

---

## View Composer / Shared Data

| Composer | Data | Scope |
|----------|------|-------|
| `{NamaComposer}` | `{data_yang_dishare}` | `{view tertentu / semua view}` |
