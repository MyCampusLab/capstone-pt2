# Security Pre-Merge Checklist (Mandatory)

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** GUIDANCE — Bagian dari security standard. Lihat [README.md](./README.md) untuk index lengkap.

###  WAJIB sebelum merge ke main:

**Credential & Environment:**
- [ ] Secret scanning: `trufflehog filesystem --since-commit HEAD~10` atau `gitleaks detect --source .`
- [ ] Tidak ada hardcoded credentials di code
- [ ] Tidak ada credential aktual (password, token, API key, SSH key, IP, database username, connection string) di file .md di dalam folder kode: `grep -rnE '(password|secret|token|key|credential|IP|host).*[:=].*[^\{]' apps/docs/` (exclude template placeholders `{...}`)
- [ ] `.env` files di `.gitignore`
- [ ] `.env.example` up-to-date dengan semua required variables
- [ ] Environment variables tidak mengandung production secrets

**HTTP Security:**
- [ ] Security headers aktif (CSP, HSTS, X-Frame-Options, dll)
- [ ] CORS configuration whitelist-based (bukan wildcard `*`)
- [ ] Rate limiting enabled untuk semua API endpoints
- [ ] HTTPS enforced (HTTP → HTTPS redirect)

**Input Validation:**
- [ ] Semua user input divalidasi dan disanitasi
- [ ] SQL injection prevention (prepared statements/parameterized queries)
- [ ] File upload validation (type, size, content)
- [ ] Path traversal prevention
- [ ] XSS prevention (output encoding)

**Authentication & Authorization:**
- [ ] Password hashing (bcrypt/argon2, cost ≥ 10)
- [ ] Session management secure (HttpOnly, Secure, SameSite)
- [ ] CSRF protection untuk state-changing operations
- [ ] Authorization checks di semua protected routes

**Code Quality:**
- [ ] SAST tools dijalankan (PHPStan level 6+, ESLint security plugin, gosec)
- [ ] Tidak ada `eval()`, `exec()`, atau dangerous functions dengan user input
- [ ] Error messages tidak expose sensitive information
- [ ] Debug mode disabled di production (`APP_DEBUG=false`)

**Dependencies:**
- [ ] `composer audit` / `npm audit` bersih dari critical vulnerabilities
- [ ] Lock files updated (`composer.lock`, `package-lock.json`)
- [ ] Tidak ada package dengan known CVEs

**Backup & Recovery:**
- [ ] Backup verification: test restore dari backup terbaru
- [ ] Backup encrypted (AES-256)
- [ ] Backup stored offsite/secure location

**Testing:**
- [ ] Security tests pass (unit tests untuk validation, auth, authorization)
- [ ] Penetration test untuk critical features (jika applicable)
- [ ] DAST scan (OWASP ZAP) untuk web applications

**Database:**
- [ ] Migrations reviewed dan reversible
- [ ] Sensitive data columns encrypted
- [ ] Database user privileges minimal (principle of least privilege)

---

Kembali ke [Index](./README.md)
