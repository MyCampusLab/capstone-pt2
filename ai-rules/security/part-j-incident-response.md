# Incident Response (Mandatory)

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** GUIDANCE — Bagian dari security standard. Lihat [README.md](./README.md) untuk index lengkap.

###  Incident Response Plan

**WAJIB dokumentasikan dan test:**

1. **Detection & Identification:**
   - Security monitoring alerts (failed logins, unusual patterns)
   - User reports (phishing, account compromise)
   - Automated scanning (IDS/IPS, WAF logs)

2. **Containment:**
   - Isolate affected systems (disable accounts, block IPs)
   - Preserve evidence (logs, memory dumps, screenshots)
   - Notify security team within 15 menit

3. **Eradication:**
   - Remove malware/backdoors
   - Patch vulnerabilities
   - Reset compromised credentials

4. **Recovery:**
   - Restore from clean backups
   - Verify system integrity
   - Monitor for recurrence (72 jam post-incident)

5. **Post-Incident:**
   - Root cause analysis (within 48 jam)
   - Update security controls
   - Document lessons learned
   - Notify affected users (jika PII compromised, < 72 jam sesuai GDPR)

**Incident Severity Levels:**
```
CRITICAL: Data breach, ransomware, production compromise → Response time: 15 menit
HIGH: Unauthorized access, privilege escalation → Response time: 1 jam
MEDIUM: Suspicious activity, policy violation → Response time: 4 jam
LOW: Minor security event, informational → Response time: 24 jam
```

---

Kembali ke [Index](./README.md)
