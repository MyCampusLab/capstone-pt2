# SOP Backup Production (Scope A — Wajib)

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Status:** PROCEDURE — AI WAJIB menjalankan ini sebagai Scope A setiap maintenance.
> **Purpose:** Prosedur standar backup aplikasi dan database dari server production ke lokal.

---

## Prerequisites

- [ ] `MAINTENANCE_ACTIVE: true` di `deployment/ssh-access.md`
- [ ] SSH config aktif dan bisa connect ke server
- [ ] Path backup lokal sudah ada (`{path-backup-lokal}`)
- [ ] Space cukup di lokal (cek: `df -h`)

---

## Step 1: Dump Database di Server

```bash
# Connect ke server
ssh {ssh-config-name}

# Dump semua database yang relevan
mysqldump -u root -p {nama_db} | gzip > /tmp/{nama_db}_$(date +%Y%m%d).sql.gz

# Catat ukuran file
ls -lh /tmp/{nama_db}_*.sql.gz

# Exit dari server
exit
```

## Step 2: Download Database Dump ke Lokal

```bash
# Download dari server via SCP
scp {ssh-config-name}:/tmp/{nama_db}_*.sql.gz {path-backup-lokal}/DB/

# Verifikasi integritas
ls -lh {path-backup-lokal}/DB/{nama_db}_*.sql.gz
gunzip -t {path-backup-lokal}/DB/{nama_db}_*.sql.gz  # test integritas gzip
```

## Step 3: Backup Aplikasi di Server

```bash
# Connect ke server
ssh {ssh-config-name}

# Zip aplikasi (exclude yang tidak perlu)
cd /var/www
tar -czf /tmp/{app-name}_$(date +%Y%m%d).tar.gz \
    --exclude='{app-name}/storage/logs' \
    --exclude='{app-name}/vendor' \
    --exclude='{app-name}/node_modules' \
    {app-name}

# Catat ukuran file
ls -lh /tmp/{app-name}_*.tar.gz

# Exit dari server
exit
```

## Step 4: Download Aplikasi ke Lokal

```bash
# Download dari server
scp {ssh-config-name}:/tmp/{app-name}_*.tar.gz {path-backup-lokal}/APPS/

# Verifikasi integritas
ls -lh {path-backup-lokal}/APPS/{app-name}_*.tar.gz
tar -tzf {path-backup-lokal}/APPS/{app-name}_*.tar.gz | head  # test integritas tar
```

## Step 5: Bersihkan File Temporary di Server

```bash
# Connect ke server
ssh {ssh-config-name}

# Hapus file temporary
rm /tmp/{nama_db}_*.sql.gz
rm /tmp/{app-name}_*.tar.gz

# Exit
exit
```

## Step 6: Verifikasi Akhir

```bash
# Cek semua file backup
ls -lhR {path-backup-lokal}/

# Catat checksum
md5 {path-backup-lokal}/DB/*.sql.gz
md5 {path-backup-lokal}/APPS/*.tar.gz
```

## Step 7: Upload ke Google Drive (Opsional)

> Jika diperlukan sebagai bukti serah terima:

```bash
# Gunakan gdrive atau rclone
rclone copy {path-backup-lokal}/ "gdrive:{folder-backup}/" --progress
```

---

## Target Backup

| Item | Server Path | Local Path | Expected Size |
|------|-----------|------------|-------------|
| DB: `{nama_db}` | `/tmp/{nama_db}_*.sql.gz` | `{path-backup-lokal}/DB/` | `{ukuran}` |
| Apps: `{app-name}` | `/tmp/{app-name}_*.tar.gz` | `{path-backup-lokal}/APPS/` | `{ukuran}` |

---

## Verification Checklist

- [ ] Semua database berhasil di-dump
- [ ] File dump tidak corrupt (test `gunzip -t`)
- [ ] Semua aplikasi berhasil di-zip
- [ ] File zip tidak corrupt (test `tar -tzf`)
- [ ] File size sesuai ekspektasi
- [ ] Checksum tercatat
- [ ] File temporary di server sudah dihapus
- [ ] Upload ke Google Drive selesai (jika diperlukan)
