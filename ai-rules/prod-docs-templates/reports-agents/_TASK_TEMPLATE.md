# {Judul Task}

> **IMMUTABLE -- AI TIDAK BOLEH mengubah file ini. Baca sebagai panduan. Untuk output, lihat mapping di ai-rules/README.md.**

> **Tanggal:** YYYY-MM-DD
> **Eksekutor:** AI Agent (CommandCode) / {nama teknisi}
> **Status:** SUCCESS / FAILED / PARTIAL

---

## Latar Belakang & Tujuan

**MENGAPA task ini dilakukan? Apa masalahnya? Apa yang ingin dicapai?**

{Jelaskan konteks dan tujuan task secara detail. Pembaca harus memahami alasan di balik task ini tanpa perlu bertanya.}

Contoh:
Server mengalami high memory usage (85%) yang menyebabkan application lambat dan beberapa request timeout. Tujuan task ini adalah mengidentifikasi penyebab memory leak dan memperbaikinya agar server kembali stabil.

---

## Kondisi Sebelum (BEFORE)

**Kondisi awal sistem SEBELUM perubahan. Service, config, masalah yang ada.**

### System Status

```bash
$ uptime
{output}

$ free -h
{output}

$ df -h
{output}

$ docker ps
{output}
```

### Application Status

```bash
$ docker logs {container_name} --tail 50
{output}
```

### Issues Identified

- {Issue 1}
- {Issue 2}
- {Issue 3}

---

## Rencana (PLAN)

**APA yang akan dilakukan, MENGAPA pendekatan ini dipilih, risiko yang diantisipasi.**

### Approach

{Jelaskan pendekatan yang dipilih dan kenapa}

Contoh:
1. Analisis memory usage per container
2. Identifikasi container dengan memory leak
3. Restart container dengan memory leak
4. Monitor selama 1 jam untuk memastikan stabil
5. Jika masih leak, increase memory limit atau fix code

### Risks

- {Risk 1}: {Mitigation}
- {Risk 2}: {Mitigation}

### Expected Outcome

{Apa yang diharapkan setelah task selesai}

---

## Eksekusi (PROCESS)

**Langkah teknis berurutan. WAJIB sertakan command, output penting, dan penjelasan.**

### Step 1: {Deskripsi step}

```bash
$ {command}
{output}
```

**Penjelasan:** {Apa yang dilakukan command ini dan kenapa}

### Step 2: {Deskripsi step}

```bash
$ {command}
{output}
```

**Penjelasan:** {Apa yang dilakukan command ini dan kenapa}

### Step 3: {Deskripsi step}

{Jika ada error, dokumentasikan error dan cara mengatasinya}

```bash
$ {command_that_failed}
{error_output}
```

**Error:** {Deskripsi error}

**Solution:**
```bash
$ {fix_command}
{output}
```

---

## Snapshot & Evidence

**WAJIB sertakan bukti teknis setelah perubahan.**

### System Status After

```bash
$ uptime
{output}

$ free -h
{output}

$ df -h
{output}

$ docker ps
{output}
```

### Application Status After

```bash
$ docker logs {container_name} --tail 50
{output}
```

### Health Check

```bash
$ curl -f http://127.0.0.1:{port}/health
{output}

$ curl -I https://{domain}
{output}
```

### Resource Usage

```bash
$ docker stats --no-stream
{output}
```

---

## Hasil Akhir (AFTER)

**Kondisi sistem SETELAH perubahan. Service status, endpoint status, config aktif.**

### Summary

{Ringkasan singkat hasil akhir}

Contoh:
Memory usage turun dari 85% ke 45%. Semua containers running stable. Application response time kembali normal (< 200ms).

### Changes Made

| Item | Before | After |
|------|--------|-------|
| Memory Usage | 85% | 45% |
| Response Time | 2-5s | < 200ms |
| Error Rate | 5% | 0.1% |

### Configuration Changes

```yaml
# File: /opt/{app_name}/docker-compose.yml
# Before:
mem_limit: 2g

# After:
mem_limit: 4g
```

---

## Dampak (IMPACT)

**Dampak terhadap pengguna, service lain, performa, keamanan.**

### User Impact

{Bagaimana perubahan ini mempengaruhi end users}

Contoh:
Users mengalami improvement signifikan dalam response time. Tidak ada downtime selama proses perbaikan.

### Service Impact

{Bagaimana perubahan ini mempengaruhi service lain}

Contoh:
Tidak ada impact ke service lain. Semua services tetap running normal.

### Performance Impact

{Impact terhadap performa sistem}

Contoh:
- Response time: 2-5s → < 200ms (95% improvement)
- Memory usage: 85% → 45% (47% reduction)
- Error rate: 5% → 0.1% (98% reduction)

### Security Impact

{Impact terhadap security, jika ada}

Contoh:
Tidak ada impact security. Perubahan hanya bersifat performance optimization.

---

## Risiko (RISK)

**Potensi masalah yang mungkin muncul di masa depan.**

### Short-term Risks

- {Risk 1}: {Likelihood} - {Mitigation}
- {Risk 2}: {Likelihood} - {Mitigation}

### Long-term Risks

- {Risk 1}: {Likelihood} - {Mitigation}
- {Risk 2}: {Likelihood} - {Mitigation}

### Monitoring Plan

{Apa yang perlu dimonitor setelah perubahan ini}

Contoh:
- Monitor memory usage setiap 1 jam selama 24 jam
- Alert jika memory > 70%
- Check logs setiap pagi selama 3 hari

---

## Rollback (ROLLBACK)

**Cara kembali ke kondisi awal dengan command.**

### Rollback Procedure

Jika perubahan ini menyebabkan masalah, ikuti langkah berikut:

```bash
# Step 1: Stop current configuration
cd /opt/{app_name}
docker compose down

# Step 2: Revert configuration
git checkout HEAD~1 docker-compose.yml

# Step 3: Restart with old configuration
docker compose up -d

# Step 4: Verify rollback
docker ps
curl -f http://127.0.0.1:{port}/health
```

### Rollback Verification

```bash
# Check system status
uptime
free -h
docker stats --no-stream

# Check application
curl -f http://127.0.0.1:{port}/health
docker logs {container_name} --tail 50
```

---

## Catatan Tambahan

**Insight, temuan tak terduga, rekomendasi untuk task selanjutnya.**

### Insights

{Pelajaran atau insight yang didapat dari task ini}

Contoh:
Memory leak disebabkan oleh query yang tidak di-paginate dengan benar. Setiap request load semua records ke memory. Perlu implementasi proper pagination di semua endpoints.

### Unexpected Findings

{Temuan tak terduga selama task}

Contoh:
Ditemukan juga bahwa Redis cache tidak dikonfigurasi dengan benar. Cache hit rate hanya 20%, seharusnya > 80%. Ini bisa jadi penyebab performance issue lainnya.

### Recommendations

{Rekomendasi untuk task atau improvement selanjutnya}

Contoh:
1. Implement proper pagination di semua list endpoints (HIGH PRIORITY)
2. Fix Redis cache configuration (MEDIUM PRIORITY)
3. Add memory usage monitoring dashboard (LOW PRIORITY)
4. Schedule code review untuk query optimization (MEDIUM PRIORITY)

### Related Tasks

- {Link ke task terkait 1}
- {Link ke task terkait 2}

### Documentation Updates

File dokumentasi yang perlu diupdate:
- [ ] `~/docs/tech-stack/{app_name}.md` - Update memory limit
- [ ] `~/docs/troubleshooting.md` - Add memory leak troubleshooting
- [ ] `~/docs/changelog.md` - Log this change
- [ ] `~/docs/operations/monitoring.md` - Add memory alerts

---

## References

- **Related Documentation:** {link ke docs terkait}
- **Related Tickets:** {link ke ticket/issue}
- **External Resources:** {link ke artikel/tutorial yang digunakan}

---

**Report Completed:** {YYYY-MM-DD HH:MM}
**Next Review:** {YYYY-MM-DD} (jika perlu follow-up)
