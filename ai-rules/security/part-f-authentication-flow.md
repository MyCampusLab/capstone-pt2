# Authentication Flow (Project-Specific)

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** GUIDANCE — Bagian dari security standard. Lihat [README.md](./README.md) untuk index lengkap.

**Isi oleh AI setelah menganalisis auth system project:**

- Session-based atau token-based (JWT, Sanctum)?
- Bagaimana session disimpan?
- Apakah ada multi-guard (admin vs user)?
- Apakah ada SSO/OAuth?
- Bagaimana "remember me" bekerja?

```
[Login Form] → [Auth Controller] → [Guard Check] → [Session/Token Create] → [Redirect]
```

---

Kembali ke [Index](./README.md)
