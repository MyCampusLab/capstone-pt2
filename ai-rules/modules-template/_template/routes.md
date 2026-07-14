# Routes — {Nama Modul}

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** DATA FILE — Update saat ada perubahan route atau middleware.

---

## Route Groups

| Group | Prefix | Middleware | Namespace |
|-------|--------|-----------|-----------|
| `{nama_group}` | `/{prefix}` | `{auth, role:admin}` | `{Modules\NamaModul}` |

---

## Endpoint Registry

| Method | URI | Name | Controller@Action | Auth | Notes |
|--------|-----|------|-------------------|------|-------|
| `GET` | `/{prefix}` | `{modul}.index` | `{NamaController}@index` | `{role}` | `{catatan}` |
| `GET` | `/{prefix}/create` | `{modul}.create` | `{NamaController}@create` | `{role}` | |
| `POST` | `/{prefix}` | `{modul}.store` | `{NamaController}@store` | `{role}` | |
| `GET` | `/{prefix}/{id}` | `{modul}.show` | `{NamaController}@show` | `{role}` | |
| `GET` | `/{prefix}/{id}/edit` | `{modul}.edit` | `{NamaController}@edit` | `{role}` | |
| `PUT` | `/{prefix}/{id}` | `{modul}.update` | `{NamaController}@update` | `{role}` | |
| `DELETE` | `/{prefix}/{id}` | `{modul}.destroy` | `{NamaController}@destroy` | `{role}` | `{konfirmasi SweetAlert}` |

---

## Special Routes (AJAX / DataTables / Import / Export)

| Method | URI | Name | Controller@Action | Purpose |
|--------|-----|------|-------------------|---------|
| `GET` | `/{prefix}/data` | `{modul}.data` | `{NamaController}@data` | DataTables server-side |
| `POST` | `/{prefix}/import` | `{modul}.import` | `{NamaController}@import` | Import data |
| `GET` | `/{prefix}/export` | `{modul}.export` | `{NamaController}@export` | Export data |

---

## Route File Location

`{routes/web.php}` atau `{routes/NamaModul.php}`
