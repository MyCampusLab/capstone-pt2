# Backup & Disaster Recovery Security (Mandatory)

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** GUIDANCE — Bagian dari security standard. Lihat [README.md](./README.md) untuk index lengkap.

###  Backup Security

**Requirements:**
1. **Encryption:** Semua backup WAJIB encrypted (AES-256)
   ```bash
   # Example: encrypt database dump
   mysqldump -u root -p"$DB_PASSWORD" dbname | \
   openssl enc -aes-256-cbc -salt -pbkdf2 -pass pass:"$BACKUP_KEY" \
   > backup-$(date +%Y%m%d).sql.enc
   ```

2. **Access Control:**
   - Backup storage: restricted access (IAM roles, not public)
   - Backup keys: stored in secrets manager (AWS Secrets Manager, HashiCorp Vault)
   - Backup logs: immutable, append-only

3. **Verification:**
   - Test restore: monthly (minimal)
   - Integrity check: checksum verification (SHA-256)
   - Backup completeness: verify all databases/files included

4. **Storage:**
   - 3-2-1 rule: 3 copies, 2 different media, 1 offsite
   - Retention: 30 days daily, 12 months monthly, 7 years yearly (adjust per regulation)
   - Geographic separation: backup di different region/datacenter

5. **Disaster Recovery:**
   - RPO (Recovery Point Objective): max data loss acceptable (e.g., 1 jam)
   - RTO (Recovery Time Objective): max downtime acceptable (e.g., 4 jam)
   - DR plan: documented, tested quarterly
   - Failover: automated jika possible

---

Kembali ke [Index](./README.md)
