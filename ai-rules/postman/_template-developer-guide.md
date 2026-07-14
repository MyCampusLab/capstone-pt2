# {Project Name} — API Developer Guide

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** DATA FILE — Dibuat jika ada developer eksternal yang consume API ini.
> **Purpose:** Panduan lengkap untuk developer mobile/frontend/third-party.

---

## 1. Overview

**{1 paragraf — apa API ini, untuk siapa, scope apa}**

---

## 2. Base URL & Environment

| Environment | Base URL |
|------------|----------|
| Local | `http://localhost:{port}` |
| Staging | `https://staging-api.{domain}` |
| Production | `https://api.{domain}` |

---

## 3. Authentication

| Item | Detail |
|------|--------|
| Method | `{Bearer Token / JWT / Sanctum / Session}` |
| Token Header | `Authorization: Bearer {your_token}` |
| Token Source | `POST /api/v1/auth/login` |
| Token Expiry | `{durasi}` |
| Rate Limit | `{limit}` |

### Login Flow

```
1. POST /api/v1/auth/login { username, password, device_name }
2. Simpan token dari response.data.token
3. Semua request berikutnya: header Authorization: Bearer {token}
4. Token expired → login ulang
```

### Example

```bash
curl -X POST {{base_url}}/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"your_username","password":"your_password","device_name":"MyApp"}'
```

Response:
```json
{
  "data": {
    "token": "1|abc123...",
    "user": { "id": 1, "name": "...", "role": "admin" }
  }
}
```

---

## 4. Standard Response Format

### Success
```json
{
  "data": { ... },
  "message": "Success"
}
```

### Paginated
```json
{
  "data": [ ... ],
  "meta": {
    "current_page": 1,
    "last_page": 10,
    "per_page": 20,
    "total": 200
  }
}
```

### Error
```json
{
  "message": "Error description",
  "errors": {
    "field": ["Validation message"]
  }
}
```

### HTTP Status Codes
| Code | Meaning |
|------|---------|
| 200 | OK |
| 201 | Created |
| 401 | Unauthorized (token invalid/expired) |
| 403 | Forbidden (tidak punya akses) |
| 404 | Not found |
| 422 | Validation error |
| 429 | Rate limit exceeded |
| 500 | Server error |

---

## 5. Endpoint Groups

### Auth

| Method | Endpoint | Purpose |
|--------|----------|---------|
| POST | `/api/v1/auth/login` | Login, dapat token |
| GET | `/api/v1/auth/profile` | Lihat profile user |
| PUT | `/api/v1/auth/profile` | Update profile |
| POST | `/api/v1/auth/logout` | Logout, revoke token |

### {Modul 1}

{jelaskan setiap modul — endpoint list, special notes, business logic yang perlu diketahui developer}

| Method | Endpoint | Purpose | Notes |
|--------|----------|---------|-------|
| GET | `/api/v1/{prefix}` | List | Pagination: `?page=&per_page=` |
| GET | `/api/v1/{prefix}/{id}` | Detail | |
| POST | `/api/v1/{prefix}` | Create | |
| PUT | `/api/v1/{prefix}/{id}` | Update | |
| DELETE | `/api/v1/{prefix}/{id}` | Delete | |

---

## 6. Special Notes / Gotchas

**Hal-hal penting yang harus diketahui developer:**
- `{catatan_1 — contoh: "Field status menggunakan enum: active, inactive, suspended"}`
- `{catatan_2 — contoh: "Upload file max 5MB, format: jpg, png, pdf"}`
- `{catatan_3 — contoh: "Rate limit: 60 req/min per token"}`

---

## 7. Postman Setup

1. Import `{project}-API.postman_collection.json` ke Postman
2. Import `{project}-API.local.postman_environment.json` ke Postman
3. Pilih environment yang sesuai
4. Jalankan `Auth > Login` — token otomatis tersimpan
5. Semua request berikutnya pakai token yang sama

---

## 8. Changelog

| Date | Endpoint | Change |
|------|----------|--------|
| `{YYYY-MM-DD}` | `{endpoint}` | `{perubahan}` |
