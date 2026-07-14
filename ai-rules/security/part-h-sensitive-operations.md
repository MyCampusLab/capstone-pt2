# Sensitive Operations (Mandatory)

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** GUIDANCE — Bagian dari security standard. Lihat [README.md](./README.md) untuk index lengkap.

###  Audit Trail & Logging

**WAJIB log semua sensitive operations dengan detail:**

| Operation | Log Details | Retention |
|-----------|-------------|-----------|
| Login/logout | User ID, IP, timestamp, success/failure, user agent | 1 year |
| Password change | User ID, timestamp, IP | 1 year |
| Data export | User ID, data type, record count, timestamp, IP | 2 years |
| Data deletion | User ID, data type, record ID, timestamp, reason | Permanent |
| Permission changes | Admin ID, target user, old/new permissions, timestamp | Permanent |
| Admin actions | Admin ID, action type, affected resources, timestamp | Permanent |
| Failed auth attempts | IP, username/email, timestamp, failure reason | 90 days |

**Log format:**
```
[2026-06-09 14:30:45] SECURITY.INFO: User login successful {"user_id":123,"ip":"192.168.1.1","user_agent":"Mozilla/5.0..."}
[2026-06-09 14:31:20] SECURITY.WARNING: Failed login attempt {"email":"admin@example.com","ip":"10.0.0.5","reason":"invalid_password"}
[2026-06-09 14:32:10] SECURITY.CRITICAL: Data export initiated {"user_id":123,"data_type":"users","record_count":5000}
```

### Two-Step Verification for Critical Operations

**WAJIB implement untuk:**
- Bulk data deletion (> 10 records)
- Export sensitive data (PII, financial)
- Permission/role changes
- System configuration changes
- Production deployment
- Database schema changes

**Implementation:**
```php
// Step 1: Request verification
POST /api/admin/users/bulk-delete
{
    "user_ids": [1, 2, 3, ...],
    "verification_token": "temp-token-123"
}

// Response:
{
    "requires_verification": true,
    "verification_url": "/api/admin/verify",
    "expires_in": 300 // 5 minutes
}

// Step 2: Verify (email/SMS/2FA)
POST /api/admin/verify
{
    "verification_token": "temp-token-123",
    "code": "123456" // from email/SMS/authenticator
}

// Response:
{
    "verified": true,
    "action_token": "verified-token-456" // valid for 10 minutes
}

// Step 3: Execute with action_token
POST /api/admin/users/bulk-delete
{
    "user_ids": [1, 2, 3, ...],
    "action_token": "verified-token-456"
}
```

### Data Masking in UI & Logs

**Masking rules:**
```javascript
// Email: show first char + domain
"john.doe@example.com" → "j*******@example.com"

// Phone: show last 4 digits
"+6281234567890" → "+6281***7890"

// Credit card: show last 4
"4111111111111111" → "****-****-****-1111"

// NIK/KTP: show last 4
"1234567890123456" → "************3456"

// Address: show city only
"Jl. Sudirman No. 123, Jakarta Pusat" → "Jakarta Pusat"
```

**Implementation:**
```php
// Backend masking helper
class DataMasker {
    public static function email(string $email): string {
        $parts = explode('@', $email);
        return substr($parts[0], 0, 1) . '*******@' . $parts[1];
    }
    
    public static function phone(string $phone): string {
        return substr($phone, 0, 5) . '***' . substr($phone, -4);
    }
    
    public static function nik(string $nik): string {
        return str_repeat('*', 12) . substr($nik, -4);
    }
}
```

### Sensitive Operations Table

| Area | Risk | Guard |
|------|------|-------|
| `{form delete}` | `{HIGH — data loss}` | `{konfirmasi + POST method + CSRF + permission check + audit log}` |
| `{export data}` | `{MEDIUM — data leak}` | `{permission check + rate limit + two-step verification + audit log}` |
| `{upload file}` | `{MEDIUM — malicious file}` | `{file validation + size limit + MIME check + virus scan}` |
| `{mass assignment}` | `{HIGH — unauthorized update}` | `{$fillable guard / DTO validation}` |
| `{bulk operations}` | `{CRITICAL — mass data change}` | `{two-step verification + audit log + rollback capability}` |
| `{admin actions}` | `{CRITICAL — privilege abuse}` | `{super admin only + audit log + notification to other admins}` |

---

Kembali ke [Index](./README.md)
