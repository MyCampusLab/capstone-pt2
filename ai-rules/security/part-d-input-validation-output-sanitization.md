# Input Validation & Output Sanitization (Mandatory)

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** GUIDANCE — Bagian dari security standard. Lihat [README.md](./README.md) untuk index lengkap.

### Input

| Rule | Detail |
|------|--------|
| Validasi input | Semua input dari user WAJIB divalidasi (FormRequest, Zod, Joi) |
| Whitelist approach | Definisikan apa yang BOLEH, bukan apa yang TIDAK BOLEH |
| File upload | Max size, allowed extensions (`jpg,png,pdf` — bukan blacklist), scan MIME type |
| SQL Injection | Gunakan ORM / prepared statements. JANGAN raw query dengan user input |
| Mass assignment | Gunakan `$fillable` / `$guarded` (Laravel) atau DTO pattern |
| **Path Traversal** | Sanitize `../` dan `..\\` di semua file path input. Gunakan `realpath()` atau `basename()` |
| **SSRF (Server-Side Request Forgery)** | Validasi dan whitelist URL/IP yang boleh diakses backend. Jangan fetch URL dari user input tanpa validasi |
| **Deserialization Attacks** | JANGAN deserialize untrusted data (PHP `unserialize()`, Java `ObjectInputStream`, Node `JSON.parse` dengan custom reviver). Gunakan JSON yang aman |
| **XXE (XML External Entity)** | Disable external entities di XML parser. Gunakan `LIBXML_NOENT` = false |
| **Command Injection** | JANGAN gunakan `exec()`, `system()`, `shell_exec()` dengan user input. Jika perlu, gunakan array argument, bukan string |
| **Race Conditions** | Gunakan database locks (FOR UPDATE) atau atomic operations untuk payment/inventory. Jangan check-then-act tanpa lock |
| **NoSQL Injection** | Validasi dan sanitize input untuk MongoDB, Firestore, dan document-based DB. Gunakan query operators yang aman, JANGAN concat user input ke query filter |
| **ReDoS (Regular Expression Denial of Service)** | Hindari regex pattern yang bisa exponential backtracking (nested quantifiers, overlapping groups). Gunakan atomic groups atau time-limited regex engine |
| **LDAP Injection** | Escape special characters (`*`, `(`, `)`, `\`, `/`) di LDAP query input. Gunakan parameterized LDAP queries |
| **Content-Type Validation** | Enforce Content-Type header pada request body (JSON API = `application/json`). Reject request dengan wrong Content-Type |

### Output

| Rule | Detail |
|------|--------|
| XSS prevention | Escape output (`{{ }}` di Blade, `v-text` di Vue, jangan `v-html` tanpa sanitasi) |
| JSON response | Jangan expose stack trace di production (`APP_DEBUG=false`) |
| Error message | Generic di production ("Server error"), detail di development |
| ID exposure | Pertimbangkan UUID sebagai ganti auto-increment ID di URL publik |
| **Data masking** | Mask sensitive data di logs dan UI (email: `j***@example.com`, phone: `08***1234`) |

---

Kembali ke [Index](./README.md)
