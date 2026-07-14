# {Nama Service} Integration

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** DATA FILE — Update saat ada perubahan integrasi.
> **Template:** Copy file ini untuk setiap integrasi baru. Ganti `{placeholder}` dengan data aktual.

---

## Service Identity

| Item | Detail |
|------|--------|
| Provider | `{nama penyedia}` |
| Purpose | `{untuk apa}` |
| Docs URL | `{link dokumentasi}` |
| SDK/Package | `{composer/npm package name}` |

---

## Authentication

| Item | Detail |
|------|--------|
| Method | `{API Key / OAuth2 / Basic Auth / IP Whitelist}` |
| Location | `{header X-Api-Key / Bearer token / .env variable}` |
| `.env` Key | `{SERVICE_API_KEY}` |
| `.env.example` | `{SERVICE_API_KEY=}` |

---

## Connection

| Item | Detail |
|------|--------|
| Base URL | `{https://api.example.com/v1}` |
| Rate Limit | `{100 req/min}` |

---

## Endpoints Used

| Method | Endpoint | Purpose | Code Location |
|--------|----------|---------|-------------|
| `{POST}` | `{/v1/resource}` | `{tujuan}` | `{App\Services\X::method()}` |

---

## Error Handling

| Scenario | Behavior | User Message |
|----------|----------|-------------|
| Timeout | `{retry 3x}` | `{pesan ke user}` |
| Invalid response | `{log + fallback}` | `{pesan ke user}` |
| Rate limited | `{queue job / retry later}` | `{pesan ke user}` |

**Fallback behavior jika gagal total:**
- `{retry 3x / queue job / fail silently / throw exception}`

---

## Testing

**Mock approach:**
```php
// {contoh kode mock dari test yg sudah ada}
```

**Sandbox/test mode:** `{URL sandbox / mode yg tersedia}`
