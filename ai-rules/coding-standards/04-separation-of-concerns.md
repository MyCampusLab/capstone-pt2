# Separation of Concerns

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** WAJIB — Bagian dari coding standards. Lihat [CODING_STANDARDS.md](../CODING_STANDARDS.md) untuk index lengkap.

### Layer Architecture (WAJIB)

Setiap aplikasi HARUS mengikuti layer architecture:

```
HTTP Request
    ↓
Controller (HTTP layer only)
    ↓
Service (Business logic)
    ↓
Repository (Database operations)
    ↓
Model (Data structure)
```

### Controller Responsibilities

**Controller HANYA boleh:**
- ✅ Receive HTTP request
- ✅ Validate input (gunakan Form Request)
- ✅ Call Service layer
- ✅ Return HTTP response

**Controller TIDAK boleh:**
- ❌ Business logic
- ❌ Database queries langsung
- ❌ File operations
- ❌ External API calls
- ❌ Complex calculations

### Service Responsibilities

**Service boleh:**
- ✅ Business logic
- ✅ Orchestrate multiple repositories
- ✅ Call external services
- ✅ Complex calculations

**Service TIDAK boleh:**
- ❌ HTTP request/response handling
- ❌ Direct database queries (gunakan Repository)

### Repository Responsibilities

**Repository HANYA boleh:**
- ✅ Database queries
- ✅ Data persistence
- ✅ Query optimization

**Repository TIDAK boleh:**
- ❌ Business logic
- ❌ HTTP handling
- ❌ External API calls

---

Kembali ke [Index](../CODING_STANDARDS.md)
