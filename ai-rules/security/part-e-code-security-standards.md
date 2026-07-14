# Code Security Standards (Mandatory)

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** GUIDANCE — Bagian dari security standard. Lihat [README.md](./README.md) untuk index lengkap.

###  AI WAJIB mengikuti saat menulis kode:

1. **Dependency audit:** Jalankan audit sebelum install package baru.
   ```bash
   npm audit    # Node.js
   composer audit  # PHP
   ```

2. **No eval / dynamic execution:**
   ```php
   // ❌ JANGAN
   eval($userInput);
   exec($userInput);
   
   // ✅ GUNAKAN
   // Whitelist command yang sudah ditentukan
   ```

3. **CORS configuration:** Jangan `Access-Control-Allow-Origin: *` di production. Whitelist domain yang diizinkan.

4. **File upload security:**
   - Simpan di luar `public/` directory
   - Gunakan random filename (jangan pakai nama asli user)
   - Validasi MIME type, bukan hanya extension
   - Batasi ukuran file

5. **Rate limiting:** Semua endpoint API WAJIB pakai rate limit. Default: 60 req/min.

6. **Logging:** 
   - Jangan log credential, token, atau data sensitif user
   - **Specific sensitive data yang TIDAK BOLEH di-log:**
     - Passwords, API keys, tokens
     - Credit card numbers, SSN, NIK
     - Full email addresses (mask: `j***@example.com`)
     - Phone numbers (mask: `08***1234`)
   - Log security events: login success/failure, permission denied, data access

7. **HTTPS enforcement:** Production WAJIB HTTPS. Redirect HTTP → HTTPS.

8. **Database backup encryption:** Jika backup DB disimpan di cloud/storage, pastikan terenkripsi.

9. **Dependencies up-to-date:** AI WAJIB cek `composer outdated` / `npm outdated` setiap milestone dan usulkan upgrade jika ada security patch.

10. **SAST (Static Application Security Testing):**
    ```bash
    # PHP
    ./vendor/bin/phpstan analyse --level=max src/
    ./vendor/bin/psalm --show-info=true
    
    # Node.js
    npx eslint-plugin-security
    npx njsscan .
    
    # Go
    gosec ./...
    staticcheck ./...
    ```

11. **DAST (Dynamic Application Security Testing):**
    - Gunakan OWASP ZAP atau Burp Suite untuk penetration testing
    - Run DAST minimal 1x per bulan untuk production
    - Integrate ke CI/CD pipeline

12. **Secure random number generation:**
    ```php
    // ❌ JANGAN (predictable)
    $token = rand();
    $id = mt_rand();
    
    // ✅ GUNAKAN (cryptographically secure)
    $token = bin2hex(random_bytes(32));
    $id = random_int(1, PHP_INT_MAX);
    ```
    ```javascript
    // ❌ JANGAN
    const token = Math.random().toString(36);
    
    // ✅ GUNAKAN
    const token = crypto.randomBytes(32).toString('hex');
    ```

13. **Timing attacks prevention:**
    ```php
    // ❌ JANGAN (timing leak)
    if ($userInput === $secretToken) { // short-circuit evaluation
        // ...
    }
    
    // ✅ GUNAKAN (constant-time comparison)
    if (hash_equals($secretToken, $userInput)) {
        // ...
    }
    ```

14. **Integer overflow/underflow:**
    - Validasi range untuk semua integer input
    - Gunakan `PHP_INT_MAX` checks
    - Hati-hati dengan operasi matematika di payment/inventory

15. **Third-party dependency verification:**
    - Verifikasi checksum/signature package sebelum install
    - Gunakan lock files (`composer.lock`, `package-lock.json`)
    - Review changelog sebelum upgrade major version
    - Hindari package dengan < 1000 downloads atau tidak maintained > 2 tahun

---

Kembali ke [Index](./README.md)
