# API Contract — {Nama Produk}

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** PLANNING — Dibuat sebelum development. HANYA untuk project fullstack (backend + frontend terpisah).
> **Purpose:** Kontrak API antara frontend dan backend. Backend harus comply ke kontrak ini. Frontend harus consume sesuai kontrak ini.

---

## 1. API Conventions

| Item | Convention |
|------|-----------|
| Base URL | `{https://api.example.com/v1}` |
| Content Type | `application/json` |
| Auth Header | `Authorization: Bearer {token}` |
| Date Format | ISO 8601 (`YYYY-MM-DDTHH:mm:ssZ`) |
| Pagination | `?page=1&per_page=20` |
| Response Envelope | `{ "data": ..., "meta": { ... } }` |

---

## 2. Standard Response Formats

### Success (200 / 201)
```json
{
    "data": { ... },
    "message": "Success message"
}
```

### Success with Pagination
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
        "field_name": ["Validation error 1", "Validation error 2"]
    }
}
```

### Unauthorized (401)
```json
{
    "message": "Unauthenticated."
}
```

### Forbidden (403)
```json
{
    "message": "This action is unauthorized."
}
```

### Not Found (404)
```json
{
    "message": "Resource not found."
}
```

### Server Error (500)
```json
{
    "message": "Internal server error."
}
```

---

## 3. Endpoints

### Module: {Nama Modul}

**List**
```
GET /api/v1/{prefix}
Query: ?page=1&per_page=20&search={keyword}&sort={field}&order={asc|desc}
Auth: required
Role: {role}

Response 200:
{
    "data": [
        {
            "id": 1,
            "name": "...",
            "created_at": "2026-01-01T00:00:00Z"
        }
    ],
    "meta": {
        "current_page": 1,
        "last_page": 1,
        "per_page": 20,
        "total": 1
    }
}
```

**Show**
```
GET /api/v1/{prefix}/{id}
Auth: required
Role: {role}

Response 200:
{
    "data": {
        "id": 1,
        "name": "...",
        "created_at": "2026-01-01T00:00:00Z"
    }
}
```

**Create**
```
POST /api/v1/{prefix}
Auth: required
Role: {role}
Body:
{
    "name": "...",
    "description": "..."
}

Response 201:
{
    "data": {
        "id": 1,
        "name": "..."
    },
    "message": "Created successfully"
}
```

**Update**
```
PUT /api/v1/{prefix}/{id}
Auth: required
Role: {role}
Body:
{
    "name": "..."
}

Response 200:
{
    "data": {
        "id": 1,
        "name": "..."
    },
    "message": "Updated successfully"
}
```

**Delete**
```
DELETE /api/v1/{prefix}/{id}
Auth: required
Role: {role}

Response 200:
{
    "message": "Deleted successfully"
}
```

---

## 4. DataTables / Server-Side Endpoint

```
GET /api/v1/{prefix}/data
Query: ?draw=1&start=0&length=10&search[value]=keyword&order[0][column]=0&order[0][dir]=desc
Auth: required
Role: {role}

Response 200:
{
    "draw": 1,
    "recordsTotal": 100,
    "recordsFiltered": 10,
    "data": [ ... ]
}
```
