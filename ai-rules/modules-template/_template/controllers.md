# Controllers — {Nama Modul}

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** DATA FILE — Update saat controller baru dibuat atau method berubah.

---

## Controller Registry

| Controller | Location | Purpose |
|-----------|----------|---------|
| `{NamaController}` | `{app/Http/Controllers/...}` | `{tanggung jawab controller ini}` |

---

## Action Details

### {NamaController}

**Path:** `{app/Http/Controllers/Modules/NamaModul/NamaController.php}`

| Method | Request Class | Purpose |
|--------|-------------|---------|
| `index()` | — | Menampilkan daftar data dengan DataTables |
| `create()` | — | Menampilkan form create |
| `store()` | `{StoreRequest}` | Menyimpan data baru |
| `show($id)` | — | Menampilkan detail |
| `edit($id)` | — | Menampilkan form edit |
| `update($id)` | `{UpdateRequest}` | Update data |
| `destroy($id)` | — | Hapus data |

---

## Form Request Classes

| Request | Location | Rules |
|---------|----------|-------|
| `{StoreRequest}` | `{app/Http/Requests/...}` | `{ringkasan rules}` |
| `{UpdateRequest}` | `{app/Http/Requests/...}` | `{ringkasan rules}` |

---

## Controller Dependencies

| Dependency | Via | Purpose |
|-----------|-----|---------|
| `{NamaService}` | Constructor injection / method injection | `{tujuan}` |
