# Data Protection & Privacy (Mandatory)

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** GUIDANCE — Bagian dari security standard. Lihat [README.md](./README.md) untuk index lengkap.

###  GDPR & PII Compliance

**Personally Identifiable Information (PII) yang WAJIB dilindungi:**
- Nama lengkap + alamat/phone/email
- NIK/KTP, passport number
- Financial data (credit card, bank account)
- Health records
- Biometric data
- Location data (GPS coordinates)

**Requirements:**
1. **Data Minimization:** Collect hanya data yang necessary
2. **Purpose Limitation:** Use data hanya untuk tujuan yang stated
3. **Storage Limitation:** Delete data setelah retention period
4. **Integrity & Confidentiality:** Encrypt PII at rest dan in transit
5. **Right to Access:** User bisa request export data mereka
6. **Right to Erasure:** User bisa request deletion (kecuali legal requirement)
7. **Data Portability:** Export dalam format machine-readable (JSON/CSV)

**Implementation:**
```php
// Data retention policy
class RetentionPolicy {
    public const USER_DATA = '5 years after last activity';
    public const TRANSACTION_DATA = '7 years (financial regulation)';
    public const LOGS = '1 year';
    public const BACKUPS = '30 days rolling';
}

// GDPR export endpoint
GET /api/user/data-export
// Returns: JSON dengan semua user data (profile, transactions, logs)

// GDPR deletion endpoint
DELETE /api/user/account
// Actions:
// 1. Anonymize PII (name → "Deleted User", email → "deleted-{id}@example.com")
// 2. Delete user-generated content (kecuali required by law)
// 3. Log deletion event
// 4. Return confirmation dengan deletion date
```

**Data Breach Notification:**
- Notify supervisory authority: < 72 jam setelah discovery
- Notify affected users: < 72 jam jika high risk
- Document: nature of breach, data categories, likely consequences, mitigation measures

---

Kembali ke [Index](./README.md)
