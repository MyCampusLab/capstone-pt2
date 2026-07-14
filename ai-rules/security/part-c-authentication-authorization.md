# Authentication & Authorization (Mandatory)

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** GUIDANCE — Bagian dari security standard. Lihat [README.md](./README.md) untuk index lengkap.

### Auth Flow

| Item | Standard |
|------|----------|
| Password hashing | `bcrypt` (cost ≥ 10) atau `argon2id` |
| Password complexity | Min 8 char, 1 uppercase, 1 number, 1 special char |
| Rate limit login | `throttle:login` — max 5 attempt per minute |
| Account lockout | Setelah 5x gagal, lock 15 menit |
| Password reset | Token expire ≤ 60 menit, single-use only |
| Session lifetime | ≤ 24 jam (production), ≤ 1 jam (admin) |
| Multi-device support | Opsional, tapi wajib ada fitur revoke token/session |
| MFA/2FA | **WAJIB untuk admin/superadmin**, optional untuk user biasa |

### Session & Token Management

- **Session invalidation** — invalidate semua session saat password change, logout, atau security event
- **Token refresh** — gunakan short-lived access token (15 menit) + long-lived refresh token (7 hari)
- **JWT revocation** — gunakan blacklist/whitelist untuk revokasi JWT sebelum expired
- **API key management** — support multiple API keys per user, revocation, dan usage tracking

### OAuth & Social Login Security

- **State parameter** — WAJIB gunakan state parameter untuk mencegah CSRF
- **Email verification** — verifikasi email sebelum grant access
- **Account linking** — hati-hati saat link social account ke existing account, verifikasi ownership
- **Scope limitation** — request hanya scope yang diperlukan (principle of least privilege)
- **Token storage** — simpan OAuth tokens encrypted di database

### RBAC / Permission

- Semua endpoint yang bukan public WAJIB pakai middleware auth
- Permission dicek via Gate/Policy, bukan hardcode role check
- Gunakan `$user->can('action', $resource)` — bukan `if ($user->role === 'admin')`
- **Permission caching** — cache permission untuk performance, tapi invalidate saat role change

### Data Ownership

- User hanya boleh mengakses data miliknya, kecuali role admin
- Filter data by user_id di query, bukan di response
- **Insecure Direct Object Reference (IDOR)** — validasi ownership sebelum return data, jangan trust ID dari URL saja

---

Kembali ke [Index](./README.md)
