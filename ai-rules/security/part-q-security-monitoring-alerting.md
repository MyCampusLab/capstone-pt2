# Security Monitoring & Alerting (Mandatory)

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** GUIDANCE — Bagian dari security standard. Lihat [README.md](./README.md) untuk index lengkap.

###  Security Monitoring

**WAJIB monitor dan alert:**

1. **Authentication Events:**
   - Failed login attempts (> 5 per menit dari same IP)
   - Successful login dari new location/device
   - Password changes
   - Account lockouts

2. **Authorization Events:**
   - Permission denied attempts
   - Privilege escalation attempts
   - Admin actions (user creation, deletion, role changes)

3. **Data Access:**
   - Bulk data exports (> 1000 records)
   - Access ke sensitive data (PII, financial)
   - Database query anomalies (slow queries, full table scans)

4. **System Events:**
   - Configuration changes
   - Deployment events
   - Service restarts
   - Disk/memory usage (> 80%)

5. **Network Events:**
   - Unusual traffic patterns
   - Port scanning attempts
   - DDoS indicators
   - Firewall rule violations

**Alerting:**
```yaml
# Example: Prometheus alerting rules
groups:
  - name: security_alerts
    rules:
      - alert: HighFailedLogins
        expr: rate(login_failures_total[5m]) > 10
        for: 2m
        labels:
          severity: critical
        annotations:
          summary: "High failed login rate detected"
          
      - alert: UnauthorizedAccess
        expr: rate(permission_denied_total[5m]) > 5
        for: 1m
        labels:
          severity: warning
        annotations:
          summary: "Multiple unauthorized access attempts"
          
      - alert: DataExfiltration
        expr: rate(data_export_bytes_total[5m]) > 100000000
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "Potential data exfiltration detected"
```

**Logging:**
- Centralized logging (ELK Stack, Splunk, Datadog)
- Immutable logs (append-only, tamper-evident)
- Log retention: 1 year (minimal), 7 years (financial/healthcare)
- Log format: structured (JSON) dengan timestamp, user_id, IP, action, result

**SIEM Integration:**
- Forward security logs ke SIEM (Security Information and Event Management)
- Correlate events across systems
- Automated incident response (SOAR - Security Orchestration, Automation, and Response)

---

Kembali ke [Index](./README.md)
