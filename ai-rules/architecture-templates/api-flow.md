# API / Request Flow Architecture

> **Status:** DATA FILE — AI WAJIB mengupdate saat ada perubahan desain sistem.
> **Purpose:** Dokumentasi flow request dari client ke response, mencakup semua layer.

---

## IMMUTABLE -- AI TIDAK BOLEH MENGUBAH FILE INI. Baca template ini, lalu BUAT file BARU di folder output (dev-docs/, planning/, dll) -- JANGAN ubah template ini.

**What to CREATE in output folder:** Dokumentasikan bagaimana request mengalir di sistem.

###  Dual-Repo: Flow Berbeda

- **Monolith** → satu flow dari browser ke controller ke view
- **Fullstack** → dua flow: (1) browser ke frontend (SSR/SPA), (2) frontend ke backend (API call)

Dokumentasikan sesuai project type.

**When to update:**
- Saat ada perubahan middleware pipeline
- Saat ada perubahan request handling pattern
- Saat ada API baru yang signifikan
- Saat ada perubahan import/export pipeline

---

## Web Request Flow

### Monolith
```
[Browser] → [Nginx/Apache] → [index.php/entrypoint] → [Middleware Pipeline] → [Router] → [Auth/Gate] → [Controller] → [Service] → [Model/DB] → [View/JSON Response]
```

### Fullstack
```
[Browser] → [CDN/Nginx] → [Frontend SSR/SPA] → [API Call] → [Backend API] → [Auth Middleware] → [Controller] → [Service] → [DB] → [JSON Response] → [Frontend Render]
```

---

## API / DataTables Flow (Fullstack)

**Dokumentasikan flow request dari frontend ke backend API:**
- Bagaimana frontend memanggil API? (fetch, axios, $fetch)
- Bagaimana auth token dikirim? (Bearer, cookie, header)
- Endpoint pattern

---

## Mutation Flow (Create/Update/Delete)

**Dokumentasikan flow mutasi data:**
- Bagaimana form submission diproses?
- Di mana validasi terjadi? (frontend + backend?)
- Apakah ada DB transaction?
- Bagaimana error handling?
- Bagaimana redirect/toast message?

---

## Import Flow (Special Pipeline)

**Dokumentasikan flow import data (jika ada):**
- Bagaimana file upload ditangani?
- Apakah pakai queue/job?
- Bagaimana chunking/large file handling?
- Bagaimana error reporting ke user?

---

## Debug Flow (Local Environment)

**Dokumentasikan tool/cara debugging:**
- Debugbar / Telescope / DevTools?
- Bagaimana log diakses?
- Bagaimana query log?
- Tools tambahan yang terpasang
