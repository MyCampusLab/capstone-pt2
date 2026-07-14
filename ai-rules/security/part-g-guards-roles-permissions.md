# Guards, Roles, & Permissions (Project-Specific)

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** GUIDANCE — Bagian dari security standard. Lihat [README.md](./README.md) untuk index lengkap.

**Isi oleh AI:**

### Guards & Providers

| Guard | Provider | Model | Purpose |
|-------|----------|-------|---------|
| `{web}` | `{users}` | `{App\Models\User}` | `{tujuan}` |

### Role & Permission Matrix

| Role | Permissions | Access Scope |
|------|------------|-------------|
| `{Super Admin}` | `{*}` | `{semua}` |
| `{role_2}` | `{perm_1, perm_2}` | `{scope}` |

### Gates & Policies

| Policy/Gate | For Model | Location |
|------------|-----------|----------|
| `{UserPolicy}` | `{User}` | `{app/Policies}` |

---

Kembali ke [Index](./README.md)
